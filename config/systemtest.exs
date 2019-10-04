use Mix.Config

config :exzeitable, PhoenixWeb.Repo,
  database: "exzeitable_system_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :exzeitable, ecto_repos: [PhoenixWebWeb.Repo]

config :exzeitable, env: :systemtest
