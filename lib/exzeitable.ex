defmodule Exzeitable do
  @moduledoc """
  # Exzeitable. Check README for usage instructions.
  """

  @doc "Expands into the gigantic monstrosity that is Exzeitable"
  defmacro __using__(opts) do
    alias Exzeitable.{Database, Filter}

    # coveralls-ignore-start
    # Required for basic functionality
    repo = Keyword.get(opts, :repo)
    routes = Keyword.get(opts, :routes)
    path = Keyword.get(opts, :path)
    query = Keyword.get(opts, :query)

    # Optional
    action_buttons = Keyword.get(opts, :action_buttons, [:new, :show, :edit, :delete])
    belongs_to = Keyword.get(opts, :belongs_to)
    per_page = Keyword.get(opts, :per_page, 20)
    parent = Keyword.get(opts, :parent)
    debounce = Keyword.get(opts, :debounce, 300)
    # Live component ID
    id = Keyword.get(opts, :id, 1)
    fields = Filter.set_fields(opts)
    search_string = Database.tsvector_string(fields)
    # coveralls-ignore-stop

    quote do
      use Phoenix.LiveView
      use Phoenix.HTML
      import Ecto.Query
      alias Phoenix.LiveView.Helpers
      alias Exzeitable.{Database, Filter, Format, HTML, Validation}
      @callback render(map) :: {:ok, iolist}
      @type socket :: Phoenix.LiveView.Socket.t()

      @doc """
      Convenience helper so LiveView doesn't have to be called directly

      ## Example

      ```
      <%= YourAppWeb.Live.Site.live_table(@conn, query: @query) %>
      ```

      """
      defdelegate build_table(assigns), to: HTML

      @spec live_table(Plug.Conn.t(), keyword) :: {:safe, iolist}
      def live_table(conn, opts \\ []) do
        session =
          %{
            "query" => Keyword.get(opts, :query, unquote(query)),
            "assigns" => Keyword.get(opts, :assigns, %{}),
            "parent" => Keyword.get(opts, :parent, unquote(parent)),
            "routes" => Keyword.get(opts, :routes, unquote(routes)),
            "repo" => Keyword.get(opts, :repo, unquote(repo)),
            "path" => Keyword.get(opts, :path, unquote(path)),
            "debounce" => unquote(debounce),
            "fields" => unquote(fields) |> Enum.map(fn {k, f} -> {k, Enum.into(f, %{})} end),
            "action_buttons" => Keyword.get(opts, :action_buttons, unquote(action_buttons)),
            "belongs_to" => Keyword.get(opts, :belongs_to, unquote(belongs_to)),
            "per_page" => Keyword.get(opts, :per_page, unquote(per_page)),
            "module" => __MODULE__,
            "page" => 1,
            "order" => nil,
            "count" => 0,
            "search" => "",
            "show_field_buttons" => false,
            "csrf_token" => Phoenix.Controller.get_csrf_token()
          }
          |> Validation.required_options()
          |> Validation.paired_options()

        Helpers.live_render(conn, __MODULE__,
          id: Keyword.get(opts, :id, unquote(id)),
          session: session
        )
      end

      ###########################
      ######## CALLBACKS ########
      ###########################

      @doc "Initial setup on page load"
      @spec mount(atom, map, socket) :: {:ok, socket}
      def mount(:not_mounted_at_router, assigns, socket) do
        assigns = Map.new(assigns, fn {k, v} -> {String.to_atom(k), v} end)

        socket =
          socket
          |> assign(assigns)
          |> maybe_get_records()
          |> maybe_set_refresh()

        {:ok, socket}
      end

      @doc "Clicking the hide button hides the column"
      @spec handle_event(String.t(), map, socket) :: {:noreply, socket}
      def handle_event("hide_column", %{"column" => column}, socket) do
        %{assigns: %{fields: fields}} = socket
        fields = Kernel.put_in(fields, [String.to_existing_atom(column), :hidden], true)

        {:noreply, assign(socket, :fields, fields)}
      end

      @doc "Clicking the show button shows the column"
      def handle_event("show_column", %{"column" => column}, socket) do
        %{assigns: %{fields: fields}} = socket
        fields = Kernel.put_in(fields, [String.to_existing_atom(column), :hidden], false)

        {:noreply, assign(socket, :fields, fields)}
      end

      @doc "Hide all the show buttons"
      def handle_event("hide_buttons", _, socket) do
        {:noreply, assign(socket, :show_field_buttons, false)}
      end

      @doc "Show all the show buttons"
      def handle_event("show_buttons", _, socket) do
        {:noreply, assign(socket, :show_field_buttons, true)}
      end

      @doc "Changes page when pagination buttons are clicked"
      def handle_event("change_page", %{"page" => page}, %{assigns: assigns} = socket) do
        new_value = %{page: String.to_integer(page)}

        socket =
          socket
          |> assign(new_value)
          |> assign(:list, Database.get_records(Map.merge(assigns, new_value)))

        {:noreply, socket}
      end

      @doc "Clicking the sort button sorts the column"
      def handle_event("sort_column", %{"column" => column}, %{assigns: assigns} = socket) do
        column = String.to_existing_atom(column)

        new_value =
          case assigns.order do
            [asc: ^column] -> %{order: [desc: column], page: 1}
            _ -> %{order: [asc: column], page: 1}
          end

        socket =
          socket
          |> assign(new_value)
          |> assign(:list, Database.get_records(Map.merge(assigns, new_value)))

        {:noreply, socket}
      end

      @doc "Typing into the search box... searches. Crazy, right?"
      def handle_event("search", %{"search" => %{"search" => search}}, socket) do
        socket =
          socket
          |> assign(%{search: search, page: 1})
          |> maybe_get_records()

        {:noreply, socket}
      end

      @doc "Refresh periodically grabs new records from the database"
      def handle_info(:refresh, socket) do
        {:noreply, maybe_get_records(socket)}
      end

      defp maybe_get_records(socket) do
        %{assigns: assigns} = socket

        if connected?(socket) do
          socket
          |> assign(:list, Database.get_records(assigns))
          |> assign(:count, Database.get_record_count(assigns))
        else
          socket
          |> assign(:list, [])
          |> assign(:count, 0)
        end
      end

      defp maybe_set_refresh(socket) do
        refresh_rate = socket.assigns[:refresh]

        if connected?(socket) && is_integer(refresh_rate) do
          :timer.send_interval(refresh_rate, self(), :refresh)
        end

        socket
      end

      # Need to unquote the search string because string interpolation is not allowed.
      @spec do_search(Ecto.Query.t(), String.t()) :: Ecto.Query.t()
      def do_search(query, search) do
        where(
          query,
          fragment(
            unquote(search_string),
            ^Database.prefix_search(search)
          )
        )
      end
    end
  end
end
