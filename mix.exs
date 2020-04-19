defmodule Exzeitable.MixProject do
  @moduledoc false
  use Mix.Project

  @version "0.3.2"

  def project do
    [
      app: :exzeitable,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

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
        mod: {Exzeitable.Application, []},
        extra_applications: [:logger, :postgrex, :ecto, :timex]
      ]
    end
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Alan Vardy"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/alanvardy/exzeitable"},
      files: [
        "lib/exzeitable.ex",
        "lib/exzeitable",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/exzeitable",
      source_url: "https://github.com/alanvardy/exzeitable",
      logo: "screenshot.png",
      filter_prefix: "Exzeitable",
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"],
        "CSS.md": [filename: "CSS"]
      ]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.3.0 or ~> 1.4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      # Ecto
      {:ecto, "~> 2.2 or ~> 3.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      # Live View
      {:phoenix_live_view, "~> 0.5"},
      {:floki, ">= 0.0.0", only: [:test, :systemtest]},
      {:timex, "~> 3.5", only: [:dev, :test, :systemtest]},
      # Tooling
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "cypress.open": ["cmd ./cypress-open.sh"],
      "cypress.ci": ["cmd ./cypress-ci.sh"],
      "cypress.run": ["cmd ./cypress-run.sh"]
    ]
  end
end
