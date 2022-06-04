defmodule Mix.Tasks.Exzeitable.Gen.MigrationTest do
  use ExUnit.Case, async: true

  alias Exzeitable.Support.FileHelpers
  import Mix.Tasks.Exzeitable.Gen.Migration, only: [run: 1]

  tmp_path = Path.join(FileHelpers.tmp_path(), inspect(Exzeitable.Gen.Migration))
  @migrations_path Path.join(tmp_path, "migrations")

  defmodule Repo do
    def __adapter__ do
      true
    end

    def config do
      [priv: "tmp/#{inspect(Exzeitable.Gen.Migration)}", otp_app: :test_web]
    end
  end

  setup do
    File.rm_rf!(unquote(tmp_path))
    :ok
  end

  test "generates a new migration" do
    [path] = run(["-r", to_string(Repo)])
    assert Path.dirname(path) === @migrations_path
    assert Path.basename(path) =~ ~r/^\d{14}_exzeitable_add_pg_trgm\.exs$/

    FileHelpers.assert_file(path, fn file ->
      assert file === """
             defmodule Mix.Tasks.Exzeitable.Gen.MigrationTest.Repo.Migrations.ExzeitableAddPgTrgm do
               use Ecto.Migration

               def change do
                 execute("CREATE EXTENSION pg_trgm", "DROP EXTENSION pg_trgm")
               end
             end
             """
    end)
  end

  test "generates a new migration with Custom Migration Module" do
    Application.put_env(:ecto_sql, :migration_module, MyCustomApp.MigrationModule)
    [path] = run(["-r", to_string(Repo), "my_custom_migration"])
    Application.delete_env(:ecto_sql, :migration_module)
    assert Path.dirname(path) === @migrations_path
    assert Path.basename(path) =~ ~r/^\d{14}_exzeitable_add_pg_trgm\.exs$/

    FileHelpers.assert_file(path, fn file ->
      assert file === """
             defmodule Mix.Tasks.Exzeitable.Gen.MigrationTest.Repo.Migrations.ExzeitableAddPgTrgm do
               use MyCustomApp.MigrationModule

               def change do
                 execute("CREATE EXTENSION pg_trgm", "DROP EXTENSION pg_trgm")
               end
             end
             """
    end)
  end

  test "custom migrations_path" do
    dir = Path.join([unquote(tmp_path), "custom_migrations"])
    [path] = run(["-r", to_string(Repo), "--migrations-path", dir, "custom_path"])
    assert Path.dirname(path) === dir
  end

  test "raises when existing migration exists" do
    run(["-r", to_string(Repo)])

    assert_raise Mix.Error, ~r"migration can't be created", fn ->
      run(["-r", to_string(Repo), "my_migration"])
    end
  end
end
