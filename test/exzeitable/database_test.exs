defmodule Exzeitable.DatabaseTest do
  @moduledoc false
  use TestWeb.DataCase, async: true
  alias Exzeitable.Database
  alias TestWeb.User

  @assigns %{
    query: from(u in User),
    parent: nil,
    routes: TestWeb.Router.Helpers,
    repo: TestWeb.Repo,
    path: :user_path,
    fields: [name: [], age: []],
    action_buttons: [],
    belongs_to: nil,
    per_page: 10,
    module: TestWeb.UserTable,
    page: 1,
    order: nil,
    count: 0,
    list: [],
    search: ""
  }

  test "get_records/1 returns a list of items when searched" do
    for _contact <- 1..3 do
      %User{name: "Dufus", age: 2} |> Repo.insert()
    end

    for _contact <- 1..5 do
      %User{name: "Smarty McSmarty Pants", age: 3} |> Repo.insert()
    end

    db_count =
      %{@assigns | search: "Dufus"}
      |> Database.get_records()
      |> Enum.count()

    assert db_count == 3
  end

  test "get_records/1 returns a list of items" do
    contacts =
      for _contact <- 1..3 do
        %User{name: "Dufus", age: 2} |> Repo.insert() |> elem(1)
      end

    assert names(Database.get_records(@assigns)) == names(contacts)
  end

  test "get_records/1 offsets based on page number" do
    for _contact <- 1..7 do
      %User{name: "Dufus", age: 2} |> Repo.insert()
    end

    db_count =
      %{@assigns | per_page: 5, page: 2}
      |> Database.get_records()
      |> Enum.count()

    assert db_count == 2
  end

  test "get_records/1 orders queries" do
    %User{name: "Dufus", age: 2} |> Repo.insert()
    %User{name: "Dingus", age: 2} |> Repo.insert()
    %User{name: "Dobbie", age: 2} |> Repo.insert()

    first =
      %{@assigns | order: [desc: :id]}
      |> Database.get_records()

    second =
      %{@assigns | order: [asc: :id]}
      |> Database.get_records()
      |> Enum.reverse()

    assert first == second
  end

  test "get_record_count/1 gets the number of records" do
    for _contact <- 1..3 do
      %User{name: "Dufus", age: 2} |> Repo.insert()
    end

    db =
      @assigns
      |> Database.get_record_count()

    assert db == 3
  end

  test "prefix_string/1 removed non-characters and appends :*" do
    assert Database.prefix_search("bananas") == "bananas:*"
    assert Database.prefix_search("baNANas") == "baNANas:*"
    assert Database.prefix_search("ba@NAN%as") == "baNANas:*"
    assert Database.prefix_search("ba_@nan%as") == "bananas:*"
  end

  test "tsvector_string/1 turns a keyword list with field metadata into a string" do
    generated =
      [id: [search: true], name: [search: true], boogers: [search: false]]
      |> Database.tsvector_string()

    expected =
      "to_tsvector('english', coalesce(id, ' ') || ' ' || coalesce(name, ' ')) @@ to_tsquery(?)"

    assert generated == expected
  end

  def names(users), do: users |> Enum.map(fn u -> Map.get(u, :name) end)
end
