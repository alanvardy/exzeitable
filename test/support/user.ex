defmodule PhoenixWeb.User do
  @moduledoc false
  use Ecto.Schema

  schema "users" do
    field(:name, :string)
    field(:age, :integer)
    has_many(:posts, PhoenixWeb.Post, on_delete: :delete_all)

    timestamps()
  end
end
