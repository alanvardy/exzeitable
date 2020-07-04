defmodule TestWeb.BeitrageTable do
  @moduledoc "Users post table in German"
  alias TestWeb.Post
  alias TestWeb.Router.Helpers, as: Routes

  use Exzeitable,
    repo: TestWeb.Repo,
    routes: Routes,
    path: :post_path,
    fields: [title: [], content: []],
    query: from(p in Post),
    text: TestWeb.GermanText,
    refresh: 5000

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
