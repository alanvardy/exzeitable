defmodule Exzeitable.HTML.Table do
  @moduledoc "Builds the table part of the HTML"
  use Exzeitable.HTML.Helpers

  alias Exzeitable.HTML.{ActionButton, Filter, Format}

  @spec build(map) :: {:safe, iolist}
  def build(%{list: list, fields: fields} = assigns) do
    head =
      fields
      |> Filter.fields_where_not(:hidden)
      |> add_actions_header(assigns)
      |> Enum.map(fn column -> table_header(column, assigns) end)
      |> cont(:thead, [])

    body =
      list
      |> Enum.map(fn entry -> build_row(entry, assigns) end)
      |> cont(:tbody, [])

    [head, body]
    |> cont(:table, class: "exz-table")
    |> maybe_nothing_found(assigns)
    |> cont(:div, class: "exz-table-wrapper")
  end

  @spec add_actions_header(keyword, map) :: keyword
  defp add_actions_header(fields, %{action_buttons: []}), do: fields

  defp add_actions_header(fields, _assigns) do
    fields ++ [actions: %{sort: false, search: false, order: false}]
  end

  @spec table_header({atom, map}, map) :: {:safe, iolist}
  defp table_header(field, assigns) do
    [Format.header(assigns, field), hide_link_for(field, assigns), sort_link_for(field, assigns)]
    |> cont(:th, [])
  end

  @spec build_row(atom, map) :: {:safe, iolist}
  defp build_row(entry, %{fields: fields} = assigns) do
    values =
      fields
      |> Filter.fields_where_not(:hidden)
      |> Keyword.keys()
      |> Enum.map(fn key -> Format.field(entry, key, assigns) end)
      |> Enum.map(fn value -> cont(value, :td, []) end)

    [values | build_actions(entry, assigns)]
    |> cont(:tr, [])
  end

  @spec build_actions(atom, map) :: {:safe, iolist}
  defp build_actions(_entry, %{action_buttons: []}), do: ""

  defp build_actions(entry, assigns) do
    assigns
    |> Map.get(:action_buttons)
    |> Kernel.--([:new])
    |> Enum.map(fn action -> ActionButton.build(action, entry, assigns) end)
    |> cont(:td, [])
  end

  @spec hide_link_for({atom, map}, map) :: {:safe, iolist} | String.t()
  defp hide_link_for({:actions, _value}, _assigns), do: ""
  defp hide_link_for(_, %{disable_hide: true}), do: ""

  defp hide_link_for({key, _value}, assigns) do
    assigns
    |> text(:hide)
    |> cont(:a,
      class: "exz-hide-link",
      "phx-click": "hide_column",
      "phx-value-column": key
    )
  end

  @spec sort_link_for({atom, map}, map) :: {:safe, iolist}
  defp sort_link_for({:actions, _v}, _), do: ""
  defp sort_link_for({_key, %{order: false}}, _), do: ""

  defp sort_link_for({key, _v}, %{order: order} = assigns) do
    sort = text(assigns, :sort)

    label =
      case order do
        [desc: ^key] -> "#{sort} ▲"
        [asc: ^key] -> "#{sort} ▼"
        _ -> "#{sort}  "
      end

    content_tag(:a, label,
      class: "exz-sort-link",
      "phx-click": "sort_column",
      "phx-value-column": key
    )
  end

  defp maybe_nothing_found(content, %{list: []} = assigns) do
    nothing_found =
      assigns
      |> text(:nothing_found)
      |> cont(:div, class: "exz-nothing-found")

    [content, nothing_found]
  end

  defp maybe_nothing_found(content, _assigns) do
    content
  end
end
