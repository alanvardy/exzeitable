defmodule TestWeb.PostTable do
  @moduledoc "Users post table"
  alias TestWeb.Post
  alias TestWeb.Router.Helpers, as: Routes

  use Exzeitable,
    repo: Exzeitable.Repo,
    routes: Routes,
    path: :post_path,
    fields: [title: [], content: []],
    query: from(p in Post)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
