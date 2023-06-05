defmodule Exzeitable.MixProject do
  use Mix.Project

  @version "0.6.2"

  def project do
    [
      app: :exzeitable,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        dialyzer: :test,
        credo: :test,
        check: :test,
        format: :test,
        doctor: :test,
        docs: :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        "coveralls.lcov": :test
      ],
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        list_unused_filters: true,
        plt_local_path: "dialyzer",
        plt_core_path: "dialyzer",
        ignore_warnings: ".dialyzer-ignore.exs",
        flags: [:unmatched_returns, :no_improper_lists, :extra_return, :missing_return]
      ],

      # Hex
      description: "Dynamically updating, searchable, sortable datatables with Phoenix LiveView",
      package: package(),

      # Docs
      name: "Exzeitable",
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    if Mix.env() == :prod do
      [
        extra_applications: [:logger, :postgrex, :ecto]
      ]
    else
      [
        mod: {TestWeb.Application, []},
        extra_applications: [:logger, :postgrex, :ecto, :timex, :runtime_tools]
      ]
    end
  end

  defp package do
    [
      maintainers: ["Alan Vardy"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/alanvardy/exzeitable"},
      files: [
        "lib/exzeitable.ex",
        "lib/exzeitable",
        "lib/mix",
        "mix.exs",
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README.md",
      canonical: "http://hexdocs.pm/exzeitable",
      source_url: "https://github.com/alanvardy/exzeitable",
      logo: "screenshot.png",
      filter_prefix: "Exzeitable",
      extras: [
        "README.md": [filename: "README.md"],
        "CHANGELOG.md": [filename: "CHANGELOG.md"],
        "CSS.md": [filename: "CSS.md"]
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:timex, "~> 3.5", only: [:dev, :test, :systemtest]},
      {:ex_check, "~>0.12", only: :test, runtime: false},
      {:credo, "~> 1.5", only: :test, runtime: false},
      {:blitz_credo_checks, "~> 0.1", only: :test, runtime: false},
      {:dialyxir, "~> 1.1", only: :test, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: [:test, :dev], runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: :test},
      {:stream_data, "~> 0.5", only: :test},
      {:doctor, "~> 0.21.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "cypress.open": ["cmd ./cypress-open.sh"],
      "cypress.run": ["cmd ./cypress-run.sh"]
    ]
  end
end
