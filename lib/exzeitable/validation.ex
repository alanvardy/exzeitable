defmodule Exzeitable.Validation do
  @moduledoc "Using these instead of Keyword.fetch! to provide nice easily resolvable errors."

  @doc "The required options"
  @spec required_options(map) :: map | nil
  def required_options(session) do
    %{
      "repo" => repo,
      "query" => query,
      "routes" => routes,
      "path" => path
    } = session

    cond do
      repo == nil ->
        raise "You need to set the repo, i.e. MyApp.Repo"

      query == nil ->
        raise "You need to set the query, i.e. from(s in Site, select: [:id, :number, :address])"

      routes == nil ->
        raise "You need to set the routes module, i.e. MyAppWeb.Router.Helpers"

      path == nil ->
        raise "You need to set the path, i.e. :user_path"

      true ->
        session
    end
  end

  @doc "If you have parent then you need belongs_to, and vice versa."
  @spec paired_options(map) :: map | nil
  def paired_options(%{"parent" => parent, "belongs_to" => belongs_to} = session) do
    cond do
      parent == nil && belongs_to != nil ->
        raise "[:parent] record needs to be defined if belongs_to is defined, i.e. Repo.find(site.id)"

      parent != nil && belongs_to == nil ->
        raise "[:belongs_to] needs to be defined if parent is defined, i.e. :site"

      true ->
        session
    end
  end
end
