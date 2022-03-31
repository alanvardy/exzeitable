defmodule Exzeitable.HTML.Table do
  @moduledoc "Builds the table part of the HTML"
  use Exzeitable.HTML.Helpers

  alias Exzeitable.Params
  alias Exzeitable.HTML.{ActionButton, Filter, Format}

  @spec build(map) :: {:safe, iolist}
  def build(%{params: %Params{fields: fields, list: list} = params} = assigns) do
    head =
      fields
      |> Filter.fields_where_not(:hidden)
      |> add_actions_header(assigns)
      |> Enum.map(fn column -> table_header(column, params) end)
      |> cont(:thead, [])

    body =
      list
      |> Enum.map(fn entry -> build_row(entry, assigns) end)
      |> cont(:tbody, [])

    [head, body]
    |> cont(:table, class: "exz-table")
    |> maybe_nothing_found(params)
    |> cont(:div, class: "exz-table-wrapper")
  end

  @spec add_actions_header(keyword, map) :: keyword
  defp add_actions_header(fields, %{params: %Params{action_buttons: []}}), do: fields

  defp add_actions_header(fields, _assigns) do
    fields ++ [actions: %{sort: false, search: false, order: false}]
  end

  @spec table_header({atom, map}, Params.t()) :: {:safe, iolist}
  defp table_header(field, %Params{} = params) do
    [Format.header(params, field), hide_link_for(field, params), sort_link_for(field, params)]
    |> cont(:th, [])
  end

  @spec build_row(atom, map) :: {:safe, iolist}
  defp build_row(entry, %{params: %Params{fields: fields}} = assigns) do
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
  defp build_actions(_entry, %{params: %Params{action_buttons: []}}), do: ""

  defp build_actions(entry, %{params: params} = assigns) do
    params
    |> Map.get(:action_buttons)
    |> Kernel.--([:new])
    |> Enum.map(fn action -> ActionButton.build(action, entry, assigns) end)
    |> cont(:td, [])
  end

  @spec hide_link_for({atom, map}, Params.t()) :: {:safe, iolist} | String.t()
  defp hide_link_for({:actions, _value}, _params), do: ""
  defp hide_link_for(_, %Params{disable_hide: true}), do: ""

  defp hide_link_for({key, _value}, %Params{} = params) do
    params
    |> text(:hide)
    |> cont(:a,
      class: "exz-hide-link",
      "phx-click": "hide_column",
      "phx-value-column": key
    )
  end

  @spec sort_link_for({atom, map}, Params.t()) :: {:safe, iolist}
  defp sort_link_for({:actions, _v}, _params), do: ""
  defp sort_link_for({_key, %{order: false}}, _params), do: ""

  defp sort_link_for({key, _v}, %Params{order: order} = params) do
    sort = text(params, :sort)

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

  defp maybe_nothing_found(content, %Params{list: []} = params) do
    nothing_found =
      params
      |> text(:nothing_found)
      |> cont(:div, class: "exz-nothing-found")

    [content, nothing_found]
  end

  defp maybe_nothing_found(content, _params) do
    content
  end
end
