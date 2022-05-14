defmodule TestWeb.ControllerTest do
  use TestWeb.ConnCase, async: true
  alias TestWeb.{Repo, User}

  describe "users" do
    setup :users

    test "Get users page via live_session", %{conn: conn} do
      conn = get(conn, "/live_session_users")

      # Only contains the table, not the outer HTML
      assert html_response(conn, 200) =~ "Name"
      assert html_response(conn, 200) =~ "Years old"
      assert html_response(conn, 200) =~ "Name backwards"
    end

    test "Get users page", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert html_response(conn, 200) =~ "Users"
    end

    test "Get formatted version", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :formatted_index))

      assert html_response(conn, 200) =~ "Listing Formatted Users"
    end
  end

  describe "posts" do
    test "Get posts page", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "Get no action buttons", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :no_action_buttons))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "Get disable hide", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :disable_hide))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "Get no pagination", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :no_pagination))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "get posts in German", %{conn: conn} do
      conn = get(conn, Routes.beitrage_path(conn, :index))

      assert html_response(conn, 200) =~ "Beiträge auflisten"
    end
  end

  defp users(_) do
    [
      %User{name: "Bob", age: 40},
      %User{name: "Suzy", age: 50},
      %User{name: "Jeff", age: 72},
      %User{name: "Alan", age: 25},
      %User{name: "Mark", age: 10},
      %User{name: "Nancy", age: 80},
      %User{name: "Sioban", age: 21}
    ]
    |> Enum.each(&Repo.insert/1)
  end
end
