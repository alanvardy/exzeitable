defmodule Exzeitable do
  @moduledoc """
  # Exzeitable

  [![Build Status](https://github.com/alanvardy/exzeitable/workflows/Elixir%20ex_check/badge.svg)](https://github.com/alanvardy/exzeitable) [![hex.pm](http://img.shields.io/hexpm/v/exzeitable.svg?style=flat)](https://hex.pm/packages/exzeitable)

  Dynamic searchable, sortable datatable that takes a database query and a module, and makes the magic happen. Uses Phoenix Liveview and Postgres. Bootstrap friendly and easily configured for other CSS frameworks.

  ![Exzeitable](assets/screenshot.png)

  ## Installation

  This package requires a Postgres database and Phoenix.

  The package can be installed by adding [exzeitable](https://github.com/alanvardy/exzeitable) and [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view) to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:exzeitable, "~> 0.1.0"}
    ]
  end
  ```

  Documentation can be found at [https://hexdocs.pm/exzeitable](https://hexdocs.pm/exzeitable).


  ## Getting Started

  ### Module

  Add the boilerplate to a new module.

  ```elixir
  defmodule YourAppWeb.Live.File do
    @moduledoc "User's File table"
    alias YourAppWeb.Router.Helpers, as: Routes
    import Ecto.Query

    use Exzeitable,
      # Required
      repo: YourApp.Repo,
      routes: Routes,
      path: :file_path,
      query: from(f in File)
      fields: [
        image: [virtual: true],
        title: [hidden: true],
        description: [hidden: true],
        category: [hidden: true],
        filesize: [hidden: true, function: true, search: false],
        inserted_at: [hidden: true, function: true, label: "Created"],
        updated_at: [hidden: true, function: true, label: "Updated"]
      ],

      # Optional
      debounce: 300

    # The callback that renders your table
    def render(assigns), do: ~L"<%= build_table(assigns) %>"

    # Field functions, called when virtual: true or function: true
    def image(socket, file) do
      img_tag(file.url, class: "w-100")
      |> link(to: Routes.file_path(socket, :show, file))
    end

    def filesize, do: ...
    def inserted_at, do: ...
    def updated_at, do: ...

  ```

  Options can be added to either your module (as seen above), or in the template (As seen below) or both.
  If an option is defined in both the template option will replace the module option. The only exception is `:fields` which must be specified in the module.

  #### Required options

    - `repo` The module for your repository. Example: `YourApp.Repo`
    - `routes` Your route module. Example: `YourAppWeb.Router.Helpers`
    - `path` The base path for your resource. Example: `:site_path`
    - `query` A Ecto.Query struct, the part before you give it to the Repo. Example: `from(s in Site, preload: [:users`

  #### Defining your fields

  Under the fields key, you can define a keyword list of atoms with keyword values. The map holds the options for that field.

  ```elixir
  fields: [
            name: [function: true],
            age: [order: false],
            metadata: [label: "Additional Information", virtual: true, hidden: true],
          ]
  ```

  The following field options are available (with their defaults):

  - `label: nil` Set a custom string value for the column heading
  - `function: false` Pass (socket, entry) to a function with the same name as the field
  - `hidden: false` Hide the column by default (user can click show button to reveal)
  - `search: true` Do not include the column in searches
  - `order: true` Do not allow the column to be sorted (hide the sort button)
  - `virtual: false` This is shorthand for [function: true, search: false, order: false] and will override those settings. Intended for creating fields that are not database backed.



  Optional... options (with defaults)

    - `action_buttons: [:new, :edit, :show, :delete]` A list of atoms representing action buttons avaliable for the user to use. This does not do authorization, the routes will still be available.
    - `per_page: 20` Integer representing number of entries per page.
    - `debounce: 300` Sets how many miliseconds between responding to user input on the search field.

  #### Options for nested routes

  If you dont know what this is then you likely don't need to worry about it. You can look at [The official docs](https://hexdocs.pm/phoenix/routing.html#nested-resources) if you would like to learn more.

  If you define one of the below options you then need to define the other.

  For this example we will be using the boring example of users and posts

  ```elixir
  resources "/users", UserController do
    resources "/posts", PostController
  end
  ```

  The users Exzeitable does not need the 2 options below, but the posts Exzeitable does. Because all of its routes are different. The following will be needed to make the posts Exzeitable work:

  - `belongs_to: :user`
  - `parent: @user`

  Make sure that you include the :user_id in your query.

  You will need to pass the parent option in from the template.

  ### Controller

  This is where you can specify the query that forms the default data of the table.
  Everything the table does is with a subset of this data.

  ```elixir
  query = from(f in Files)
  render(conn, "index.html", query: query)
  ```

  ### Template

  And call the table from your template

  ```elixir
  <h1> My Awesome Files </h1>
  <%= YourAppWeb.Live.File.live_table(@conn, query: @query, action_buttons: [:show, :edit]) %>
  ```

  ## Contributing

  Contributions are very welcome! Open an issue or a pull request, the code, tests and documentation can always be improved and I welcome the help :)

  """

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
    fields = Filter.set_fields(opts)
    search_string = Database.tsvector_string(fields)
    # coveralls-ignore-stop

    quote do
      use Phoenix.LiveView
      use Phoenix.HTML
      import Ecto.Query
      alias Exzeitable.{Database, Filter, Format, HTML, Validation}

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
            query: Keyword.get(opts, :query, unquote(query)),
            parent: Keyword.get(opts, :parent, unquote(parent)),
            routes: Keyword.get(opts, :routes, unquote(routes)),
            repo: Keyword.get(opts, :repo, unquote(repo)),
            path: Keyword.get(opts, :path, unquote(path)),
            debounce: unquote(debounce),
            fields: unquote(fields) |> Enum.map(fn {k, f} -> {k, Enum.into(f, %{})} end),
            action_buttons: Keyword.get(opts, :action_buttons, unquote(action_buttons)),
            belongs_to: Keyword.get(opts, :belongs_to, unquote(belongs_to)),
            per_page: Keyword.get(opts, :per_page, unquote(per_page)),
            module: __MODULE__,
            page: 1,
            order: nil,
            count: 0,
            search: ""
          }
          |> Validation.required_options()
          |> Validation.paired_options()

        Phoenix.LiveView.live_render(conn, __MODULE__, session: session)
      end

      ###########################
      ######## CALLBACKS ########
      ###########################

      @doc "Initial setup on page load"
      @spec mount(map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
      def mount(assigns, socket) do
        socket =
          socket
          |> assign(assigns)
          |> assign(:list, Database.get_records(assigns))
          |> assign(:count, Database.get_record_count(assigns))

        {:ok, socket}
      end

      @doc "Clicking the hide button hides the column"
      @spec handle_event(String.t(), map, Phoenix.LiveView.Socket.t()) ::
              {:noreply, Phoenix.LiveView.Socket.t()}
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
        %{assigns: assigns} = socket

        new_params = %{search: search, page: 1}

        socket =
          socket
          |> assign(new_params)
          |> assign(:list, Database.get_records(Map.merge(assigns, new_params)))
          |> assign(:count, Database.get_record_count(Map.merge(assigns, new_params)))

        {:noreply, socket}
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
