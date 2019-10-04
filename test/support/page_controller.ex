defmodule PhoenixWeb.PageController do
  use PhoenixWeb, :controller
  import Ecto.Query
  alias PhoenixWeb.{Post, User}

  @spec posts(Plug.Conn.t(), any) :: Plug.Conn.t()
  def posts(conn, _params) do
    posts = from(p in Post, preload: [:user])

    render(conn, "posts.html", posts: posts)
  end

  @spec users(Plug.Conn.t(), any) :: Plug.Conn.t()
  def users(conn, _params) do
    users = from(u in User, preload: [:posts])

    render(conn, "users.html", users: users)
  end
end
