defmodule ExzeitableWeb.PageControllerTest do
  @moduledoc false
  use ExzeitableWeb.ConnCase, async: true
  alias Exzeitable.Repo
  alias ExzeitableWeb.User

  describe "Pages" do
    test "Get posts page", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))

      assert html_response(conn, 200) =~ "Posts"
    end

    test "Get users page", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      [
        %User{name: "Bob", age: 40},
        %User{name: "Suzy", age: 50},
        %User{name: "Jeff", age: 72},
        %User{name: "Alan", age: 25},
        %User{name: "Mark", age: 10},
        %User{name: "Nancy", age: 80},
        %User{name: "Sioban", age: 21}
      ]
      |> Enum.map(&Repo.insert/1)

      assert html_response(conn, 200) =~ "Users"
    end
  end
end
