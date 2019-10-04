defmodule PhoenixWeb.PageControllerTest do
  @moduledoc false
  use PhoenixWeb.ConnCase, async: true

  describe "Pages" do
    test "Get posts page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :posts))

      assert html_response(conn, 200) =~ "SUCCESS"
    end

    test "Get users page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :users))

      assert html_response(conn, 200) =~ "SUCCESS"
    end
  end
end
