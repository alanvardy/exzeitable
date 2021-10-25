defmodule Exzeitable.HTML.ActionButtonTest do
  @moduledoc false
  use TestWeb.DataCase, async: true
  alias Exzeitable.{Database, HTML.Filter}
  alias Exzeitable.HTML.ActionButton
  alias TestWeb.{Post, User}

  @assigns %{
    query: from(p in Post, preload: [:user]),
    parent: nil,
    routes: TestWeb.Router.Helpers,
    repo: TestWeb.Repo,
    path: :post_path,
    fields: [title: [], content: []],
    action_buttons: [],
    belongs_to: nil,
    per_page: 50,
    module: TestWeb.PostTable,
    page: 1,
    order: nil,
    count: 0,
    list: [],
    search: ""
  }

  describe "parent_for/1" do
    test "selects the parent for the item" do
      {:ok, user} = %User{name: "Dufus", age: 2} |> Repo.insert()

      {:ok, _post} =
        %Post{
          title: "I picked my nose today",
          content: "It was rather amazing. Would do again.",
          user_id: user.id
        }
        |> Repo.insert()

      assigns = %{@assigns | belongs_to: :user, list: Database.get_records(@assigns)}

      db =
        assigns
        |> Map.get(:list)
        |> List.first()
        |> ActionButton.parent_for(assigns)

      assert db.name == user.name
    end

    test "raises an error when it cannot find the field" do
      {:ok, user} = %User{name: "Dufus", age: 2} |> Repo.insert()

      {:ok, _post} =
        %Post{
          title: "I picked my nose today",
          content: "It was rather amazing. Would do again.",
          user_id: user.id
        }
        |> Repo.insert()

      assigns = %{
        @assigns
        | list: Database.get_records(@assigns),
          query: from(p in Post, select: [:id])
      }

      assert_raise RuntimeError,
                   "You need to select the association in :belongs_to",
                   fn ->
                     assigns
                     |> Map.get(:list)
                     |> List.first()
                     |> ActionButton.parent_for(assigns)
                   end
    end
  end

  test "fields_where/2 returns all the fields for which an attribute is true" do
    list = [
      item_one: %{boogers: false},
      item_two: %{boogers: true},
      item_three: %{boogers: true},
      item_four: %{boogers: false}
    ]

    resulting_list = [
      item_two: %{boogers: true},
      item_three: %{boogers: true}
    ]

    assert Filter.fields_where(list, :boogers) == resulting_list
  end

  test "fields_where_not/2 returns all the fields for which an attribute is false" do
    list = [
      item_one: %{boogers: false},
      item_two: %{boogers: true},
      item_three: %{boogers: true},
      item_four: %{boogers: false}
    ]

    resulting_list = [
      item_one: %{boogers: false},
      item_four: %{boogers: false}
    ]

    assert Filter.fields_where_not(list, :boogers) == resulting_list
  end
end
