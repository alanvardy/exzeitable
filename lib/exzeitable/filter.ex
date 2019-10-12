defmodule Exzeitable.Filter do
  @moduledoc "Filtering data"

  @default_fields [
    label: nil,
    function: false,
    hidden: false,
    search: true,
    order: true
  ]

  @virtual_fields [
    function: true,
    search: false,
    order: false
  ]

  @doc "Gets the parent that the nested resource belongs to"
  @spec parent_for(map, map) :: map | nil
  def parent_for(entry, %{belongs_to: belongs_to}) do
    case Map.get(entry, belongs_to) do
      nil -> raise "You need to select the association in :belongs_to"
      result -> result
    end
  end

  @doc "Selects the page buttons we need for pagination"
  @spec filter_pages(integer, integer) :: [String.t() | Integer]
  def filter_pages(pages, _page) when pages <= 7, do: 1..pages

  def filter_pages(pages, page) when page in [1, 2, 3, pages - 2, pages - 1, pages] do
    [1, 2, 3, "....", pages - 2, pages - 1, pages]
  end

  def filter_pages(pages, page) do
    [1, "...."] ++ [page - 1, page, page + 1] ++ ["....", pages]
  end

  @doc "Returns true if any of the fields have search enabled"
  @spec search_enabled?(map) :: boolean
  def search_enabled?(%{fields: fields}) do
    fields
    |> Enum.filter(fn {_k, field} -> Map.get(field, :search) end)
    |> Enum.any?()
  end

  @doc "All fields where a key value is true"
  @spec fields_where([keyword], atom) :: [keyword]
  def fields_where(fields, attribute) do
    fields
    |> Enum.filter(fn {_k, field} -> Map.get(field, attribute) end)
  end

  @doc "All fields where a key value is false"
  @spec fields_where_not([keyword], atom) :: [keyword]
  def fields_where_not(fields, attribute) do
    fields
    |> Enum.reject(fn {_k, field} -> Map.get(field, attribute) end)
  end

  @doc "Gets fields from options and merges it into the defaults"
  @spec set_fields(keyword) :: [any]
  def set_fields(opts) do
    opts
    |> Keyword.get(:fields, [])
    |> Enum.map(fn {key, field} -> {key, merge_fields(field)} end)
  end

  # If virtual: true, a number of other options have to be overridden
  @spec merge_fields(keyword) :: keyword
  defp merge_fields(field) do
    if Keyword.get(field, :virtual) do
      @default_fields
      |> Keyword.merge(field)
      |> Keyword.merge(@virtual_fields)
    else
      Keyword.merge(@default_fields, field)
    end
  end
end
