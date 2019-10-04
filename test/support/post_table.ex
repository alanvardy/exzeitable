defmodule PhoenixWeb.PostTable do
  @moduledoc "Users post table"
  alias PhoenixWeb.Post
  alias PhoenixWeb.Router.Helpers, as: Routes

  use Exzeitable,
    repo: PhoenixWeb.Repo,
    routes: Routes,
    action_buttons: [],
    path: :page_path,
    fields: [title: [], content: []],
    query: from(p in Post)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
