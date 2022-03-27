defmodule TestWeb.UserFormattedTable do
  @moduledoc "User table"
  alias TestWeb.Router.Helpers, as: Routes
  alias TestWeb.User

  use Exzeitable,
    repo: TestWeb.Repo,
    routes: Routes,
    path: :user_path,
    fields: [
      name: [formatter: {TestWeb.UserFormattedTable, :format}],
      age: [label: "Years old", search: false],
      name_backwards: [formatter: {TestWeb.UserFormattedTable, :format, ["!!!"]}, virtual: true]
    ],
    query: from(u in User),
    per_page: 5

  def render(assigns), do: ~H"<%= build_table(assigns) %>"

  def name_backwards(_socket, entry) do
    entry
    |> Map.get(:name)
    |> String.reverse()
  end

  def format(value) do
    "<<< " <> to_string(value) <> " >>>"
  end

  def format(value, string) do
    string <> to_string(value) <> string
  end
end
