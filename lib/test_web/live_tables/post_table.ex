defmodule TestWeb.PostTable do
  @moduledoc "Users post table"
  alias TestWeb.Post
  alias TestWeb.Router.Helpers, as: Routes

  use Exzeitable,
    repo: TestWeb.Repo,
    routes: Routes,
    path: :post_path,
    fields: [title: [], content: []],
    query: from(p in Post),
    action_buttons: [:show, :edit, :custom_button],
    refresh: 5000

  def render(assigns), do: ~H"<%= build_table(assigns) %>"

  def custom_button(_socket, _entry, _csrf_token), do: "CUSTOM BUTTON"
end
