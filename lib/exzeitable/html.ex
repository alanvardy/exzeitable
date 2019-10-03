defmodule Exzeitable.HTML do
  @moduledoc """
  
  You will need to add styling for the form, I attempted to make the classes as unopiniated as possible.

  Below is a SASS example for Bootstrap 4

  ```
  // #############################
  // ########### TABLE ###########
  // #############################

  // div around the table
  .lt-table-wrapper {
    @extend .table-responsive;
  }

  // the table
  .lt-table {
    @extend .table;
    thead {
      @extend .thead-dark;
    }
  }

  // div around lt-pagination-div and lt-search-div
  .lt-row {
    @extend .row;
  }

  // #############################
  // ########### SEARCH ##########
  // #############################

  // div around the search box
  .lt-search-wrapper {
    @extend .col-xl-6;
  }

  //The search form (I don't need this)
  // .lt-search-form {

  // }

  .lt-search-field {
    @extend .form-control;
    @extend .mb-1;
  }

  .lt-search-field-wrapper {
    @extend .input-group-append;
  }

  .lt-counter-field {
    @extend .input-group-text;
  }

  .lt-counter-field-wrapper {
    @extend .input-group-append;
    @extend .mb-1;
  }

  // #############################
  // ######## PAGINATION #########
  // #############################

  // div around the pagination nav
  .lt-pagination-wrapper {
    @extend .col-xl-6;
  }
  // nav around pagination ul
  .lt-pagination-nav {
    @extend .mt-1;
    @extend .mt-xl-0;
  }

  // ul around pagination li
  .lt-pagination-ul {
    @extend .pagination;
    @extend .pagination-sm;
  }

  // li around pagination links
  .lt-pagination-li {
    @extend .page-item;
  }

  // li around pagination links when active
  .lt-pagination-li-active {
    @extend .page-item;
    @extend .active;
    color: white;
  }

  // li around pagination links when disabled
  .lt-pagination-li-disabled {
    @extend .page-item;
    @extend .disabled;
  }

  // Base class for pagination link
  .lt-pagination-a {
    @extend .page-link;
    @extend .text-center;
    @extend .mt-1;
  }

  // Fixed width for pagination link with number
  .lt-pagination-width {
    width: 50px;
  }

  // #############################
  // ####### Header Links ########
  // #############################


  // Hide link
  .lt-hide-link {
    @extend .mx-1;
    @extend .small;
    cursor: grabbing;
  }

  // Sort link
  .lt-sort-link {
    @extend .mx-1;
    @extend .small;
    cursor: grabbing;
  }

  // Buttons for showing hidden columns
  .lt-show-button {
    @extend .btn;
    @extend .btn-sm;
    @extend .btn-outline-secondary;
    @extend .m-1;
    cursor: grabbing;
  }
    // #############################
    // ###### Action Buttons #######
    // #############################

  .lt-action-delete {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-danger;
  }

  .lt-action-new {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-primary;
  }

  .lt-action-show {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-primary;
  }

  .lt-action-edit {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-info;
  }
  """
  use Phoenix.HTML
  alias Exzeitable.{Filter, Format}

  @spec build_table(map) :: [binary | {:safe, iolist}]
  def build_table(assigns) do
    assigns
    |> head_section()
    |> body_section(assigns)
    |> cont(:table, class: "lt-table")
    |> cont(:div, class: "lt-table-wrapper")
    |> build_outer(assigns)
  end

  @spec head_section(map) :: {:safe, iolist}
  defp head_section(assigns) do
    assigns
    |> Map.get(:fields)
    |> Filter.fields_where_not(:hidden)
    |> Kernel.++(actions: %{sort: false, search: false, order: false})
    |> Enum.map(fn column -> table_header(column, assigns) end)
    |> cont(:thead, [])
  end

  @spec body_section({:safe, iolist | binary}, map) :: [{:safe, iolist}]
  defp body_section(head_section, %{list: list} = assigns) do
    body =
      list
      |> Enum.map(fn entry -> build_row(entry, assigns) end)
      |> cont(:tbody, [])

    [head_section, body]
  end

  @spec build_outer({:safe, iolist}, map) :: [binary | {:safe, iolist}]
  defp build_outer(contents, assigns) do
    search_box = build_search(assigns)
    new_button = build_action_button(:new, assigns)
    show_buttons = show_buttons(assigns)
    pagination = build_pagination(assigns)
    navigation = [pagination, search_box]

    [
      cont(navigation, :div, class: "lt-row"),
      new_button,
      show_buttons,
      contents,
      new_button,
      show_buttons,
      pagination
    ]
  end

  @spec build_search(map) :: {:safe, iolist}
  defp build_search(%{debounce: debounce} = assigns) do
    if Filter.search_enabled?(assigns) do
      form_for(:search, "#", [phx_change: :search, class: "lt-search-form"], fn f ->
        [
          text_input(f, :search,
            placeholder: "Search",
            class: "lt-search-field",
            phx_debounce: debounce
          ),
          counter(assigns)
        ]
        |> cont(:div, class: "lt-search-field-wrapper")
      end)
      |> cont(:div, class: "lt-search-wrapper")
    else
      ""
    end
  end

  defp counter(%{count: count}) do
    cont(count, :span, class: "lt-counter-field")
    |> cont(:div, class: "lt-counter-field-wrapper")
  end

  @spec table_header({atom, map}, map) :: {:safe, iolist}
  defp table_header(field, assigns) do
    [Format.header(field), hide_link_for(field), sort_link_for(field, assigns)]
    |> cont(:th, [])
  end

  @spec build_row(atom, map) :: {:safe, iolist}
  defp build_row(entry, assigns) do
    values =
      assigns
      |> Map.get(:fields)
      |> Filter.fields_where_not(:hidden)
      |> Keyword.keys()
      |> Enum.map(fn key -> Format.field(entry, key, assigns) end)
      |> Enum.map(fn value -> cont(value, :td, []) end)

    [values | build_actions(entry, assigns)]
    |> cont(:tr, [])
  end

  @spec build_actions(atom, map) :: {:safe, iolist}
  defp build_actions(entry, assigns) do
    assigns
    |> Map.get(:action_buttons)
    |> Kernel.--([:new])
    |> Enum.map(fn action -> build_action_button(action, entry, assigns) end)
    |> cont(:td, [])
  end

  @spec build_pagination(map) :: {:safe, iolist}
  defp build_pagination(%{page: page} = assigns) do
    pages = page_count(assigns)

    ([paginate_button("Previous", page, pages)] ++
       numbered_buttons(page, pages) ++
       [paginate_button("Next", page, pages)])
    |> cont(:ul, class: "lt-pagination-ul")
    |> cont(:nav, class: "lt-pagination-nav")
    |> cont(:div, class: "lt-pagination-wrapper")
  end

  @spec numbered_buttons(integer, integer) :: [{:safe, iolist}]
  defp numbered_buttons(_page, 0) do
    [paginate_button(1, 1, 1)]
  end

  defp numbered_buttons(page, pages) do
    pages
    |> Filter.filter_pages(page)
    |> Enum.map(fn x -> paginate_button(x, page, pages) end)
  end

  defp page_count(%{count: count, per_page: per_page}) do
    if rem(count, per_page) > 0 do
      div(count, per_page) + 1
    else
      div(count, per_page)
    end
  end

  # Used everywhere to make it easier to pipe HTML chunks into each other
  @spec cont(any(), atom, keyword) :: {:safe, iolist}
  defp cont(body, tag, opts), do: content_tag(tag, body, opts)

  ###########################
  ######### BUTTONS #########
  ###########################

  @spec paginate_button(String.t() | integer, integer, integer) :: {:safe, iolist}
  defp paginate_button("Next", page, pages) when page == pages do
    cont("Next", :a, class: "lt-pagination-a", tabindex: "-1")
    |> cont(:li, class: "lt-pagination-li-disabled")
  end

  defp paginate_button("Previous", 1, _pages) do
    cont("Previous", :a, class: "lt-pagination-a", tabindex: "-1")
    |> cont(:li, class: "lt-pagination-li-disabled")
  end

  defp paginate_button("....", _page, _pages) do
    cont("....", :a, class: "lt-pagination-a lt-pagination-width", tabindex: "-1")
    |> cont(:li, class: "lt-pagination-li-disabled")
  end

  defp paginate_button("Next", page, _pages) do
    cont("Next", :a,
      class: "lt-pagination-a",
      style: "cursor: grabbing",
      "phx-click": "change_page",
      "phx-value-page": page + 1
    )
    |> cont(:li, class: "lt-pagination-li")
  end

  defp paginate_button("Previous", page, _pages) do
    cont("Previous", :a,
      class: "lt-pagination-a",
      style: "cursor: grabbing",
      "phx-click": "change_page",
      "phx-value-page": page - 1
    )
    |> cont(:li, class: "lt-pagination-li")
  end

  defp paginate_button(same, same, _pages) do
    cont(same, :a, class: "lt-pagination-a lt-pagination-width")
    |> cont(:li, class: "lt-pagination-li-active")
  end

  defp paginate_button(label, _page, _pages) do
    cont(label, :a,
      class: "lt-pagination-a lt-pagination-width",
      style: "cursor: grabbing",
      "phx-click": "change_page",
      "phx-value-page": label
    )
    |> cont(:li, class: "lt-pagination-li")
  end

  @spec hide_link_for({atom, map}) :: {:safe, iolist}
  defp hide_link_for({:actions, _value}), do: ""

  defp hide_link_for({key, _value}) do
    cont("hide", :a,
      class: "lt-hide-link",
      "phx-click": "hide_column",
      "phx-value-column": key
    )
  end

  @spec sort_link_for({atom, map}, map) :: {:safe, iolist}
  defp sort_link_for({:actions, _v}, _), do: ""
  defp sort_link_for({_key, %{order: false}}, _), do: ""

  defp sort_link_for({key, _v}, %{order: order}) do
    label =
      case order do
        [desc: ^key] -> "sort ▲"
        [asc: ^key] -> "sort ▼"
        _ -> "sort  "
      end

    cont(label, :a,
      class: "lt-sort-link",
      "phx-click": "sort_column",
      "phx-value-column": key
    )
  end

  @spec show_buttons(map) :: [any()]
  defp show_buttons(assigns) do
    assigns
    |> Map.get(:fields)
    |> Filter.fields_where(:hidden)
    |> Enum.map(fn field -> build_show_button(field) end)
  end

  defp build_show_button({key, _value} = field) do
    name = Format.header(field)

    "Show #{name}"
    |> cont(:a,
      class: "lt-show-button",
      "phx-click": "show_column",
      "phx-value-column": key
    )
  end

  # New, create, show etc.
  @spec build_action_button(atom, atom, map) :: {:safe, iolist}
  defp build_action_button(:new, %{parent: nil} = assigns) do
    %{socket: socket, routes: routes, path: path, action_buttons: action_buttons} = assigns

    if Enum.member?(action_buttons, :new) do
      apply(routes, path, [socket, :new])
      |> html_button(:new)
    else
      ""
    end
  end

  defp build_action_button(:new, %{parent: parent} = assigns) do
    %{socket: socket, routes: routes, path: path, action_buttons: action_buttons} = assigns

    if Enum.member?(action_buttons, :new) do
      apply(routes, path, [socket, :new, parent])
      |> html_button(:new)
    else
      ""
    end
  end

  defp build_action_button(:delete, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :delete, entry])
    |> html_button(:delete)
  end

  defp build_action_button(:delete, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    params = [socket, :delete, Filter.parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html_button(:delete)
  end

  defp build_action_button(:show, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :show, entry])
    |> html_button(:show)
  end

  defp build_action_button(:show, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    params = [socket, :show, Filter.parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html_button(:show)
  end

  defp build_action_button(:edit, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :edit, entry])
    |> html_button(:edit)
  end

  defp build_action_button(:edit, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns
    params = [socket, :edit, Filter.parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html_button(:edit)
  end

  @spec html_button(String.t(), atom) :: {:safe, iolist}
  defp html_button(route, :new), do: link("New", to: route, class: "lt-action-new")
  defp html_button(route, :show), do: link("Show", to: route, class: "lt-action-show")
  defp html_button(route, :edit), do: link("Edit", to: route, class: "lt-action-edit")

  defp html_button(route, :delete) do
    link("Delete",
      to: route,
      class: "lt-action-delete",
      method: :delete,
      "data-confirm": "Are you sure?"
    )
  end
end
