use Mix.Config

config :exzeitable, Exzeitable.Phoenix.Repo,
  database: "exzeitable_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :exzeitable, ecto_repos: [Exzeitable.Phoenix.Repo]

config :exzeitable, Exzeitable.Phoenix.Repo,
  database: "exzeitabledb",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
