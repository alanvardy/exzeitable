defmodule Exzeitable.Phoenix.User do
  @moduledoc false
  use Ecto.Schema

  schema "users" do
    field(:name, :string)
    field(:age, :integer)
    has_many(:posts, Exzeitable.Phoenix.Post, on_delete: :delete_all)

    timestamps()
  end
end
