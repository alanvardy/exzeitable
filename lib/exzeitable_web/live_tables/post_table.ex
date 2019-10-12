defmodule ExzeitableWeb.PostTable do
  @moduledoc "Users post table"
  alias ExzeitableWeb.Post
  alias ExzeitableWeb.Router.Helpers, as: Routes

  use Exzeitable,
    repo: Exzeitable.Repo,
    routes: Routes,
    path: :post_path,
    fields: [title: [], content: []],
    query: from(p in Post)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
