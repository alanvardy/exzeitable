defmodule Mix.Tasks.Exzeitable.Gen.Migration do
  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator
  import Mix.Ecto
  import Mix.EctoSQL

  @shortdoc "Generates a new migration for trgm"

  @name "exzeitable_add_pg_trgm"

  @aliases [
    r: :repo
  ]

  @switches [
    repo: [:string, :keep],
    no_compile: :boolean,
    no_deps_check: :boolean,
    migrations_path: :string
  ]

  @moduledoc """
  Generates a migration file adding the pg_trgm extension to postgres.

  The repository must be set under `:ecto_repos` in the
  current app configuration or given via the `-r` option.

  ## Example

      $ mix exzeitable.gen.migration
      $ mix exzeitable.gen.migration -r Custom.Repo

  By default, the migration will be generated to the
  "priv/YOUR_REPO/migrations" directory of the current application
  but it can be configured to be any subdirectory of `priv` by
  specifying the `:priv` key under the repository configuration.

  This generator will automatically open the generated file if
  you have `ECTO_EDITOR` set in your environment variable.

  ## Command line options

    * `-r`, `--repo` - the repo to generate migration for
    * `--no-compile` - does not compile applications before running
    * `--no-deps-check` - does not check dependencies before running
    * `--migrations-path` - the path to run the migrations from, defaults to `priv/repo/migrations`

  ## Configuration

  If the current app configuration specifies a custom migration module
  the generated migration code will use that rather than the default
  `Ecto.Migration`:

      config :ecto_sql, migration_module: MyApplication.CustomMigrationModule

  """

  @impl true
  def run(args) do
    repos = parse_repo(args)

    Enum.map(repos, fn repo ->
      {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)
      ensure_repo(repo, args)
      path = opts[:migrations_path] || Path.join(source_repo_priv(repo), "migrations")
      base_name = "#{underscore(@name)}.exs"
      file = Path.join(path, "#{timestamp()}_#{base_name}")
      unless File.dir?(path), do: create_directory(path)

      fuzzy_path = Path.join(path, "*_#{base_name}")

      if Path.wildcard(fuzzy_path) != [] do
        Mix.raise(
          "migration can't be created, there is already a migration file with name #{@name}."
        )
      end

      # The :change option may be used by other tasks but not the CLI
      assigns = [mod: Module.concat([repo, Migrations, camelize(@name)])]
      create_file(file, migration_template(assigns))

      if open?(file) and Mix.shell().yes?("Do you want to run this migration?") do
        Mix.Task.run("ecto.migrate", ["-r", inspect(repo), "--migrations-path", path])
      end

      file
    end)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  defp migration_module do
    case Application.get_env(:ecto_sql, :migration_module, Ecto.Migration) do
      migration_module when is_atom(migration_module) -> migration_module
      other -> Mix.raise("Expected :migration_module to be a module, got: #{inspect(other)}")
    end
  end

  embed_template(:migration, """
  defmodule <%= inspect @mod %> do
    use <%= inspect migration_module() %>

    def change do
      execute("CREATE EXTENSION pg_trgm", "DROP EXTENSION pg_trgm")
    end
  end
  """)
end
