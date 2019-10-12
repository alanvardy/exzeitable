defmodule ExzeitableWeb.PageControllerTest do
  @moduledoc false
  use ExzeitableWeb.ConnCase, async: true

  describe "Pages" do
    test "Get posts page", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "Get users page", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert html_response(conn, 200) =~ "Users"
    end
  end
end
