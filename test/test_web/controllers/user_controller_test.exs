defmodule TestWeb.UserControllerTest do
  use TestWeb.ConnCase, async: true
  alias TestWeb.{Repo, User}

  setup do
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

  test "Get users page", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :index))

    assert html_response(conn, 200) =~ "Users"
  end
end
