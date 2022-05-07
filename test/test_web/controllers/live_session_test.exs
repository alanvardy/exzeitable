defmodule TestWeb.LiveSessionTest do
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

  test "Get users page via live_session", %{conn: conn} do
    conn = get(conn, "/live_session_users")

    # Only contains the table, not the outer HTML
    assert html_response(conn, 200) =~ "Name"
    assert html_response(conn, 200) =~ "Years old"
    assert html_response(conn, 200) =~ "Name backwards"
  end
end