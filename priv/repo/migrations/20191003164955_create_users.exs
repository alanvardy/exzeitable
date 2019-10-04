defmodule PhoenixWeb.Repo.Migrations.CreateUsersAndPosts do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table("users") do
      add(:name, :string, size: 40)
      add(:age, :integer)

      timestamps()
    end

    create table("posts") do
      add(:title, :string)
      add(:content, :text)
      add(:user_id, :integer)

      timestamps()
    end
  end

  def down do
    drop(table("users"))
    drop(table("posts"))
  end
end
