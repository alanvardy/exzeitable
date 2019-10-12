use Mix.Config

config :exzeitable, Exzeitable.Repo,
  database: "exzeitable_system_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :exzeitable, ecto_repos: [Exzeitable.Repo]

config :exzeitable, env: :systemtest

config :exzeitable, Exzeitable.Endpoint,
  secret_key_base: "PuPVb+cWuZmcKPrLR+Cydi2BhbQ+Q+hOqN1cOKYC3QnTzUTWb0HLyfx1enJVot6r",
  http: [port: 5000],
  url: [host: "localhost"],
  render_errors: [view: ExzeitableWeb.ErrorView, accepts: ~w(html json)],
  server: true,
  live_view: [
    signing_salt: "`mix phx.gen.secret 32`"
  ],
  pubsub: [name: Exzeitable.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
