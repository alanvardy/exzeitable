defmodule Exzeitable.HTML.ActionButtonTest do
  @moduledoc false
  use TestWeb.ConnCase, async: true
  import Ecto.Query

  require Phoenix.ChannelTest
  alias Exzeitable.{Database, Params}
  alias Exzeitable.HTML.{ActionButton, Filter}
  alias TestWeb.{Post, Repo, User}

  @params %Params{
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
    search: "",
    csrf_token: Phoenix.Controller.get_csrf_token()
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

      params = %Params{@params | belongs_to: :user, list: Database.get_records(@params)}

      db =
        params
        |> Map.get(:list)
        |> List.first()
        |> ActionButton.parent_for(params)

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

      params = %{
        @params
        | list: Database.get_records(@params),
          query: from(p in Post, select: [:id])
      }

      assert_raise RuntimeError,
                   "You need to select the association in :belongs_to",
                   fn ->
                     params
                     |> Map.get(:list)
                     |> List.first()
                     |> ActionButton.parent_for(params)
                   end
    end
  end

  describe "fields_where/2" do
    test "returns all the fields for which an attribute is true" do
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

    test "returns all the fields for which an attribute is false" do
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

  describe "build/2" do
    # test "can build a new action button with a parent", %{conn: conn} do
    #   user = %User{name: "Dufus", age: 2} |> Repo.insert()

    #   assigns = %{
    #     socket: conn,
    #     params: %Params{@params | belongs_to: :user, parent: user, action_buttons: [:new]}
    #   }

    #   assert nil = ActionButton.build(:new, assigns)
    # end
    test "can build a new action button", %{conn: conn} do
      assigns = %{
        socket: conn,
        params: %Params{@params | action_buttons: [:new]}
      }

      assert {:safe,
              [
                60,
                "a",
                [" class=\"", "exz-action-new", 34, 32, "href", 61, 34, "/posts/new", 34],
                62,
                "New",
                60,
                47,
                "a",
                62
              ]} = ActionButton.build(:new, assigns)
    end

    test "does not build new action button when it is not required", %{conn: conn} do
      assigns = %{socket: conn, params: @params}

      assert {:safe, [""]} = ActionButton.build(:new, assigns)
    end

    test "can build a show action button", %{conn: conn} do
      assigns = %{socket: conn, params: @params}

      {:ok, post} =
        %Post{title: "Post number 1", content: "THIS IS CONTENT", user_id: 1} |> Repo.insert()

      assert {:safe,
              [
                60,
                "a",
                [" class=\"", "exz-action-show", 34, 32, "href", 61, 34, address, 34],
                62,
                "Show",
                60,
                47,
                "a",
                62
              ]} = ActionButton.build(:show, post, assigns)

      assert address === "/posts/#{post.id}"
    end

    test "can build an edit action button", %{conn: conn} do
      assigns = %{socket: conn, params: @params}

      {:ok, post} =
        %Post{title: "Post number 1", content: "THIS IS CONTENT", user_id: 1} |> Repo.insert()

      assert {:safe,
              [
                60,
                "a",
                [" class=\"", "exz-action-edit", 34, 32, "href", 61, 34, address, 34],
                62,
                "Edit",
                60,
                47,
                "a",
                62
              ]} = ActionButton.build(:edit, post, assigns)

      assert address === "/posts/#{post.id}/edit"
    end

    test "can build a delete action button", %{conn: conn} do
      assigns = %{socket: conn, params: @params}

      {:ok, post} =
        %Post{title: "Post number 1", content: "THIS IS CONTENT", user_id: 1} |> Repo.insert()

      csrf_token = @params.csrf_token

      assert {
               :safe,
               [
                 60,
                 "a",
                 [
                   " class=\"",
                   "exz-action-delete",
                   34,
                   " data",
                   45,
                   "csrf",
                   61,
                   34,
                   ^csrf_token,
                   34,
                   " data",
                   45,
                   "method",
                   61,
                   34,
                   "delete",
                   34,
                   " data",
                   45,
                   "to",
                   61,
                   34,
                   address,
                   34,
                   32,
                   "data-confirm",
                   61,
                   34,
                   "Are you sure?",
                   34,
                   32,
                   "href",
                   61,
                   34,
                   address,
                   34,
                   32,
                   "rel",
                   61,
                   34,
                   "nofollow",
                   34
                 ],
                 62,
                 "Delete",
                 60,
                 47,
                 "a",
                 62
               ]
             } = ActionButton.build(:delete, post, assigns)

      assert address === "/posts/#{post.id}"
    end
  end
end
