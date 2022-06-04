defmodule Exzeitable.ParamsTest do
  @moduledoc false
  use TestWeb.DataCase, async: true

  import Ecto.Query

  alias Exzeitable.Params
  alias Exzeitable.Params.ParameterError
  alias TestWeb.Post

  describe "new/3" do
    test "creates a new params struct" do
      assert %Exzeitable.Params{
               action_buttons: [:new, :show, :edit, :delete],
               assigns: %{},
               belongs_to: nil,
               count: 0,
               debounce: 300,
               disable_hide: false,
               fields: [],
               formatter: {Exzeitable.HTML.Format, :format_field},
               list: [],
               module: TestWeb.PostTable,
               order: nil,
               page: 1,
               pagination: [:top, :bottom],
               parent: nil,
               path: :post_path,
               per_page: 20,
               refresh: false,
               repo: TestWeb.Repo,
               routes: TestWeb.Router.Helpers,
               search: "",
               show_field_buttons: false,
               text: Exzeitable.Text.Default
             } =
               Params.new(
                 [repo: TestWeb.Repo, routes: TestWeb.Router.Helpers],
                 [query: from(p in Post), path: :post_path],
                 TestWeb.PostTable
               )
    end

    test "requires repo parameter" do
      assert_raise ParameterError, ~r/You need to set the repo/, fn ->
        Params.new(
          [routes: TestWeb.Router.Helpers],
          [query: from(p in Post), path: :post_path],
          TestWeb.PostTable
        )
      end
    end

    test "requires routes parameter" do
      assert_raise ParameterError, ~r/You need to set the routes module/, fn ->
        Params.new(
          [repo: TestWeb.Repo],
          [query: from(p in Post), path: :post_path],
          TestWeb.PostTable
        )
      end
    end

    test "requires query parameter" do
      assert_raise ParameterError, ~r/You need to set the query/, fn ->
        Params.new(
          [
            repo: TestWeb.Repo,
            routes: TestWeb.Router.Helpers,
            path: :post_path
          ],
          [],
          TestWeb.PostTable
        )
      end
    end

    test "requires path parameter" do
      assert_raise ParameterError, ~r/You need to set the path/, fn ->
        Params.new(
          [],
          [
            repo: TestWeb.Repo,
            routes: TestWeb.Router.Helpers,
            query: from(p in Post)
          ],
          TestWeb.PostTable
        )
      end
    end
  end

  describe "set_fields/2" do
    test "merges fields over the defaults" do
      opts = [
        fields: [
          first: [label: "something"]
        ]
      ]

      after_merge = [
        first: [
          function: false,
          hidden: false,
          search: true,
          order: true,
          formatter: {Exzeitable.HTML.Format, :format_field},
          label: "something"
        ]
      ]

      assert Params.set_fields(opts) === after_merge
    end

    test "overwrites other options when virtual: true is set" do
      opts = [
        fields: [
          first: [label: "something", virtual: true]
        ]
      ]

      after_merge = [
        first: [
          hidden: false,
          formatter: {Exzeitable.HTML.Format, :format_field},
          label: "something",
          virtual: true,
          function: true,
          search: false,
          order: false
        ]
      ]

      assert Params.set_fields(opts) === after_merge
    end
  end
end
