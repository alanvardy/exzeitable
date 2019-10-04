defmodule PhoenixWeb.Post do
  @moduledoc false
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    field(:content, :string)
    belongs_to(:user, PhoenixWeb.User)

    timestamps()
  end
end
