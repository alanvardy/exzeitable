defmodule Exzeitable.Database do
  @moduledoc "Database interactions"
  import Ecto.Query

  @doc "Get the data using query"
  @spec get_records(map) :: [map]
  def get_records(%{query: query} = assigns) do
    query
    |> order_query(assigns)
    |> search_query(assigns)
    |> paginate_query(assigns)
    |> get_query(assigns)
  end

  @spec order_query(Ecto.Query.t(), map) :: Ecto.Query.t()
  defp order_query(query, %{order: nil}), do: query

  defp order_query(query, %{order: order}),
    do: from(q in exclude(query, :order_by), order_by: ^order)

  @spec search_query(Ecto.Query.t(), map) :: Ecto.Query.t()
  defp search_query(query, %{search: ""}), do: query

  defp search_query(query, %{search: search, module: module}) do
    apply(module, :do_search, [query, search])
  end

  @spec remove_order(Ecto.Query.t()) :: Ecto.Query.t()
  defp remove_order(query), do: exclude(query, :order_by)

  @spec paginate_query(Ecto.Query.t(), map) :: Ecto.Query.t()
  defp paginate_query(query, %{per_page: per_page, page: page}) do
    offset =
      if page == 1 do
        0
      else
        (page - 1) * per_page
      end

    from(q in query, limit: ^per_page, offset: ^offset)
  end

  # Filter out the previous selects and preloads, because we only need the ids to get a count
  @spec select_ids(Ecto.Query.t()) :: Ecto.Query.t()
  defp select_ids(query) do
    query =
      query
      |> exclude(:select)
      |> exclude(:preload)

    from(q in query, select: count(q.id))
  end

  # Repo.all
  @spec get_query(Ecto.Query.t(), map) :: [map]
  defp get_query(query, %{repo: repo}), do: apply(repo, :all, [query])

  @doc "I want to just do a select: count(c.id)"
  @spec get_record_count(map) :: integer
  def get_record_count(%{query: query} = assigns) do
    query
    |> select_ids()
    |> search_query(assigns)
    |> remove_order()
    |> get_query(assigns)
    |> List.first()
  end

  @doc "We only want letters to avoid SQL injection attacks"
  @spec prefix_search(String.t()) :: String.t()
  def prefix_search(term) do
    term
      |> String.split()
      |> Enum.map(&("#{String.replace(&1, ~r/\W|_/u, "")}:*"))
      |> Enum.join(" & ")
  end

  @doc """
    Generates the magic SQL fragment that performs search dynamically.
    Created outside macro to bypass ecto restrictions
  """
  @spec tsvector_string([keyword]) :: String.t()
  def tsvector_string(fields) do
    deep_search_fields = fields
      |> Enum.filter(fn {_f, fopts} -> Keyword.has_key?(fopts, :deep_search) end)
      |> Enum.map(fn {_f, fopts} ->
        Keyword.fetch!(fopts, :deep_search)
        |> Enum.map(&("coalesce(#{&1}, ' ')"))
        |> Enum.join(" || ' ' || ")
      end)

    search_columns =
      fields
      |> Enum.filter(fn {_k, fopts} -> Keyword.fetch!(fopts, :search) end)
      |> Enum.map(fn {key, _v} -> "coalesce(#{Atom.to_string(key)}, ' ')" end)
      |> Enum.concat(deep_search_fields)
      |> Enum.join(" || ' ' || ")

    "to_tsvector('english', #{search_columns}) @@ to_tsquery(?)"
  end

end
