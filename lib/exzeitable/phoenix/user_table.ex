defmodule Exzeitable.Phoenix.UserTable do
  @moduledoc "Users site table"
  alias Exzeitable.Phoenix.Router.Helpers, as: Routes
  alias Exzeitable.Phoenix.User

  use Exzeitable,
    repo: Exzeitable.Phoenix.Repo,
    routes: Routes,
    path: :user_path,
    fields: [name: [], age: []],
    query: from(u in User)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"
end
