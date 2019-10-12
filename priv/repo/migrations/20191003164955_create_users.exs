defmodule Exzeitable.Repo.Migrations.CreateUsersAndPosts do
  @moduledoc false
  use Ecto.Migration

  def up do
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

    execute("CREATE EXTENSION pg_trgm")
  end

  def down do
    drop(table("users"))
    drop(table("posts"))
    execute("DROP EXTENSION pg_trgm")
  end
end
