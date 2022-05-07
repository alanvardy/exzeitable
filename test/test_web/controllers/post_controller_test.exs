defmodule TestWeb.PageControllerTest do
  use TestWeb.ConnCase, async: true

  test "Get posts page", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :index))

    assert html_response(conn, 200) =~ "Posts"
  end
end
