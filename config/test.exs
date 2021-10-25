import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# Configure your database
config :exzeitable, TestWeb.Repo,
  username: "postgres",
  password: "postgres",
  database: "exzeitable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :exzeitable, ecto_repos: [TestWeb.Repo]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exzeitable, TestWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TWcjWX7DBOzUcY30UQJvqcwCq8K2u6AdeEvHLAPGBku4Dt5ex+RitAcyDCFsZJwt",
  server: false

# In test we don't send emails.
config :exzeitable, Exzeitable.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
