defmodule TestWeb.PageController do
  use TestWeb, :controller
  @type conn :: Plug.Conn.t()

  @spec index(conn, map) :: conn
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
