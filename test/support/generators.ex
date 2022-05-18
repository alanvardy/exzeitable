defmodule Exzeitable.Support.Generators do
  @moduledoc """
  Generators for property-based testing
  """
  use ExUnitProperties

  import Ecto.Query

  alias Exzeitable.Params
  alias TestWeb.Post

  @actions [:new, :edit, :show, :delete]

  def actions do
    gen all list <- list_of(member_of(@actions), max_length: 4) do
      list
    end
  end

  def not_new_action do
    gen all action <- member_of(@actions -- [:new]) do
      action
    end
  end

  def action do
    gen all action <- member_of(@actions) do
      action
    end
  end

  def post do
    gen all title <- string(:alphanumeric),
            content <- string(:alphanumeric),
            user_id <- positive_integer(),
            id <- positive_integer() do
      %TestWeb.Post{id: id, title: title, content: content, user_id: user_id}
    end
  end

  def params do
    gen all buttons <- actions(),
            label <- one_of([string(:alphanumeric), nil]),
            label2 <- one_of([string(:alphanumeric), nil]),
            hidden <- boolean(),
            hidden2 <- boolean(),
            order <- boolean(),
            order2 <- boolean(),
            per_page <- positive_integer(),
            page <- positive_integer(),
            search_string <- string(:alphanumeric),
            search2 <- boolean(),
            search3 <- boolean(),
            count <- one_of([positive_integer(), constant(0)]),
            posts <- list_of(post()) do
      %Params{
        query: from(p in Post, preload: [:user]),
        parent: nil,
        routes: TestWeb.Router.Helpers,
        repo: TestWeb.Repo,
        path: :post_path,
        fields: [
          title: %{
            formatter: {Exzeitable.HTML.Format, :format_field},
            function: false,
            hidden: hidden,
            label: label,
            order: order,
            search: search2
          },
          content: %{
            formatter: {Exzeitable.HTML.Format, :format_field},
            function: false,
            hidden: hidden2,
            label: label2,
            order: order2,
            search: search3
          }
        ],
        action_buttons: buttons,
        belongs_to: nil,
        per_page: per_page,
        module: TestWeb.PostTable,
        page: page,
        order: nil,
        count: count,
        list: posts,
        search: search_string,
        csrf_token: Phoenix.Controller.get_csrf_token()
      }
    end
  end
end
