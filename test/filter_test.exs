defmodule Exzeitable.FilterTest do
  @moduledoc false
  use ExzeitableWeb.DataCase, async: true
  alias Exzeitable.{Database, Filter}
  alias ExzeitableWeb.{Post, User}

  @assigns %{
    query: from(p in Post, preload: [:user]),
    parent: nil,
    routes: ExzeitableWeb.Router.Helpers,
    repo: Exzeitable.Repo,
    path: :post_path,
    fields: [title: [], content: []],
    action_buttons: [],
    belongs_to: nil,
    per_page: 50,
    module: ExzeitableWeb.PostTable,
    page: 1,
    order: nil,
    count: 0,
    list: [],
    search: ""
  }

  test "parent_for/1 selects the parent for the item" do
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
      |> Filter.parent_for(assigns)

    assert db.name == user.name
  end

  test "parent_for/1 raises an error when it cannot find the field" do
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
                   |> Filter.parent_for(assigns)
                 end
  end

  test "filter_pages/2 returns no more than 7 buttons no matter the entry" do
    for pages <- 1..20 do
      button_count = Filter.filter_pages(1, pages) |> Enum.count()
      assert button_count <= 7
      button_count = Filter.filter_pages(5, pages) |> Enum.count()
      assert button_count <= 7
    end
  end
end
