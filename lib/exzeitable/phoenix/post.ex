defmodule Exzeitable.Phoenix.Post do
  @moduledoc false
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    field(:content, :string)
    belongs_to(:user, Exzeitable.Phoenix.User)

    timestamps()
  end
end
