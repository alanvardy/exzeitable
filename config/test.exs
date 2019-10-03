use Mix.Config

# Configure your database
config :exzeitable, Exzeitable.Phoenix.Repo,
  username: "postgres",
  password: "postgres",
  database: "exzeitable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exzeitable, Exzeitable.Endpoint,
  http: [port: 4002],
  server: false

config :exzeitable, env: :test

# Print only warnings and errors during test
config :logger, level: :warn
