defmodule Exzeitable.Support.Generators do
  @moduledoc """
  Generators for property-based testing
  """
  use ExUnitProperties

  import Ecto.Query

  alias Exzeitable.Params
  alias TestWeb.Post

  @actions [:new, :edit, :show, :delete]

  def action_buttons do
    gen all new <- boolean(),
            show <- boolean(),
            delete <- boolean(),
            edit <- boolean() do
      [
        if(new, do: :new),
        if(show, do: :show),
        if(delete, do: :delete),
        if(edit, do: :edit)
      ]
      |> Enum.reject(&is_nil/1)
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

  def params do
    gen all buttons <- action_buttons() do
      %Params{
        query: from(p in Post, preload: [:user]),
        parent: nil,
        routes: TestWeb.Router.Helpers,
        repo: TestWeb.Repo,
        path: :post_path,
        fields: [title: [], content: []],
        action_buttons: buttons,
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
    end
  end
end
