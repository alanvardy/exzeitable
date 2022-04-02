defmodule TestWeb.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :age, :integer
    has_many :posts, TestWeb.Post, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
