defmodule Exzeitable.MixProject do
  use Mix.Project

  def project do
    [
      app: :exzeitable,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2 or ~> 3.0"},
      {:phoenix, "~> 1.3.0 or ~> 1.4.0"},
      {:phoenix_html, ">= 2.0.0 and <= 3.0.0"},
      {:plug, ">= 1.5.0 and < 2.0.0", optional: true},
      {:phoenix_ecto, "~> 4.0.0", only: [:dev, :test]},
      {:phoenix_live_view, "~> 0.3.0"},
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.8", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end
end
