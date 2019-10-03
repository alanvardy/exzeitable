defmodule Exzeitable.MixProject do
  @moduledoc false
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :exzeitable,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],

      # Hex
      description: "Dynamically updating, searchable, sortable datatables with Phoenix LiveView",
      package: package(),

      # Docs
      name: "Exzeitable",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Exzeitable.Phoenix.Application, []},
      extra_applications: [:logger, :postgrex, :ecto, :timex]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Alan Vardy"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/alanvardy/exzeitable"},
      files: ~w(lib mix.exs README.md )
    ]
  end

  defp docs do
    [
      markdown_processor: ExDoc.Exzeitable.Markdown,
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/exzeitable",
      source_url: "https://github.com/alanvardy/exzeitable",
      logo: "assets/screenshot.png",
      assets: "assets",
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"],
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2 or ~> 3.0"},
      {:phoenix, "~> 1.3.0 or ~> 1.4.0"},
      {:phoenix_html, ">= 2.0.0 and <= 3.0.0"},
      {:plug, ">= 1.5.0 and < 2.0.0", optional: true},
      {:phoenix_ecto, "~> 4.0.0"},
      {:ecto_sql, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, "~> 0.15.0"},
      {:phoenix_live_view, "~> 0.3.0"},
      {:timex, "~> 3.5", only: [:dev, :test]},
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
