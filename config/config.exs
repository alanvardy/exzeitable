# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configure your database
config :exzeitable, TestWeb.Repo,
  username: "postgres",
  password: "postgres",
  database: "exzeitable_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :exzeitable, ecto_repos: [TestWeb.Repo]

# Configures the endpoint
config :exzeitable, TestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OOPA//jwKZu7BThkw/h/nCKOzozSSugm+4Xo4FYq893EpUe9BLPy9stfVfClKyQP",
  render_errors: [view: TestWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exzeitable.PubSub,
  live_view: [signing_salt: "xvB6U8L/"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :exzeitable, Exzeitable.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
