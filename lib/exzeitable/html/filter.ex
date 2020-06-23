defmodule Exzeitable.HTML.Filter do
  @moduledoc "Filtering data"

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
end
