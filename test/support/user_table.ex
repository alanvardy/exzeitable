defmodule PhoenixWeb.UserTable do
  @moduledoc "User table"
  alias PhoenixWeb.Router.Helpers, as: Routes
  alias PhoenixWeb.User

  use Exzeitable,
    repo: PhoenixWeb.Repo,
    routes: Routes,
    path: :page_path,
    action_buttons: [],
    fields: [name: [], age: []],
    query: from(u in User)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
