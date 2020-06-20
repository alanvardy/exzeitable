defmodule TestWeb.Post do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:content, :string)
    belongs_to(:user, TestWeb.User)

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
