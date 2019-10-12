use Mix.Config

config :exzeitable, Exzeitable.Repo,
  database: "exzeitable_system_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :exzeitable, ecto_repos: [Exzeitable.Repo]

config :exzeitable, env: :systemtest

config :exzeitable, ExzeitableWeb.Endpoint,
  http: [port: 5000],
  server: true,
  live_view: [
    signing_salt: "`mix phx.gen.secret 32`"
  ]
