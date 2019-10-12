defmodule ExzeitableWeb.UserTable do
  @moduledoc "User table"
  alias ExzeitableWeb.Router.Helpers, as: Routes
  alias ExzeitableWeb.User

  use Exzeitable,
    repo: Exzeitable.Repo,
    routes: Routes,
    path: :page_path,
    action_buttons: [],
    fields: [name: [], age: []],
    query: from(u in User),
    per_page: 5

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
