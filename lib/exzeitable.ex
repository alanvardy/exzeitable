defmodule Exzeitable do
  @moduledoc """
  # Exzeitable. Check README for usage instructions.
  """

  @doc "Expands into the gigantic monstrosity that is Exzeitable"
  defmacro __using__(opts) do
    alias Exzeitable.{Database, Params}

    search_string =
      opts
      |> Params.set_fields()
      |> Database.tsvector_string()

    # coveralls-ignore-stop

    quote do
      use Phoenix.LiveView
      use Phoenix.HTML
      import Ecto.Query
      alias Phoenix.LiveView.Helpers
      alias Exzeitable.{Database, Filter, Format, HTML, Params, Validation}
      @callback render(map) :: {:ok, iolist}
      @type socket :: Phoenix.LiveView.Socket.t()

      @doc """
      Convenience helper so LiveView doesn't have to be called directly

      ## Example

      ```
      <%= YourAppWeb.Live.Site.live_table(@conn, query: @query) %>
      ```

      """
      defdelegate build_table(assigns), to: HTML, as: :build

      @spec live_table(Plug.Conn.t(), keyword) :: {:safe, iolist}
      def live_table(conn, opts \\ []) do
        Helpers.live_render(conn, __MODULE__,
          # Live component ID
          id: Keyword.get(unquote(opts), :id, 1),
          session: Params.new(opts, unquote(opts), __MODULE__)
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
        %{assigns: %{params: %Params{fields: fields}}} = socket
        fields = Kernel.put_in(fields, [String.to_existing_atom(column), :hidden], true)

        {:noreply, assign_params(socket, :fields, fields)}
      end

      @doc "Clicking the show button shows the column"
      def handle_event("show_column", %{"column" => column}, socket) do
        %{assigns: %{params: %Params{fields: fields}}} = socket
        fields = Kernel.put_in(fields, [String.to_existing_atom(column), :hidden], false)

        {:noreply, assign_params(socket, :fields, fields)}
      end

      @doc "Hide all the show buttons"
      def handle_event("hide_buttons", _, socket) do
        {:noreply, assign_params(socket, :show_field_buttons, false)}
      end

      @doc "Show all the show buttons"
      def handle_event("show_buttons", _, socket) do
        {:noreply, assign_params(socket, :show_field_buttons, true)}
      end

      @doc "Changes page when pagination buttons are clicked"
      def handle_event("change_page", %{"page" => page}, %{assigns: %{params: params}} = socket) do
        new_params = Map.put(params, :page, String.to_integer(page))

        socket
        |> assign_params(:page, new_params.page)
        |> assign_params(:list, Database.get_records(new_params))
        |> then(&{:noreply, &1})
      end

      @doc "Clicking the sort button sorts the column"
      def handle_event(
            "sort_column",
            %{"column" => column},
            %{assigns: %{params: params}} = socket
          ) do
        column = String.to_existing_atom(column)

        new_order =
          case params.order do
            [asc: ^column] -> [desc: column]
            _ -> [asc: column]
          end

        new_params = Map.merge(params, %{order: new_order, page: 1})

        socket
        |> assign_params(:page, 1)
        |> assign_params(:order, new_order)
        |> assign_params(:list, Database.get_records(new_params))
        |> then(&{:noreply, &1})
      end

      @doc "Typing into the search box... searches. Crazy, right?"
      def handle_event("search", %{"search" => %{"search" => search}}, socket) do
        socket
        |> assign_params(:search, search)
        |> assign_params(:page, 1)
        |> maybe_get_records()
        |> then(&{:noreply, &1})
      end

      @doc "Refresh periodically grabs new records from the database"
      def handle_info(:refresh, socket) do
        {:noreply, maybe_get_records(socket)}
      end

      defp maybe_get_records(socket) do
        %{assigns: %{params: params}} = socket

        if connected?(socket) do
          socket
          |> assign_params(:list, Database.get_records(params))
          |> assign_params(:count, Database.get_record_count(params))
        else
          socket
          |> assign_params(:list, [])
          |> assign_params(:count, 0)
        end
      end

      defp maybe_set_refresh(%{socket: %{assigns: %{refresh: refresh}}} = socket)
           when is_integer(refresh) do
        with true <- connected?(socket),
             {:ok, _tref} <- :timer.send_interval(refresh, self(), :refresh) do
          socket
        else
          _ -> socket
        end
      end

      defp maybe_set_refresh(socket) do
        socket
      end

      defp assign_params(%{assigns: %{params: params}} = socket, key, value) do
        params
        |> Map.put(key, value)
        |> then(&assign(socket, :params, &1))
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
