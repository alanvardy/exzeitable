defmodule ExzeitableWeb.UserTable do
  @moduledoc "User table"
  alias ExzeitableWeb.Router.Helpers, as: Routes
  alias ExzeitableWeb.User

  use Exzeitable,
    repo: Exzeitable.Repo,
    routes: Routes,
    path: :user_path,
    fields: [name: [], age: [label: "Years old"], name_backwards: [virtual: true]],
    query: from(u in User),
    per_page: 5

  def render(assigns), do: ~L"<%= build_table(assigns) %>"

  def name_backwards(_socket, entry) do
    entry
    |> Map.get(:name)
    |> String.reverse()
  end
end
