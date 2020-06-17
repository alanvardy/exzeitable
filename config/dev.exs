use Mix.Config

# Configure your database
config :exzeitable, Exzeitable.Repo,
  username: "postgres",
  password: "postgres",
  database: "exzeitable_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :exzeitable, ecto_repos: [Exzeitable.Repo]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exzeitable, TestWeb.Endpoint,
  secret_key_base: "PuPVb+cWuZmcKPrLR+Cydi2BhbQ+Q+hOqN1cOKYC3QnTzUTWb0HLyfx1enJVot6r",
  render_errors: [view: TestWeb.ErrorView, accepts: ~w(html json)],
  http: [port: 4000],
  url: [host: "localhost"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  server: true,
  pubsub_server: Exzeitable.PubSub,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_view: [
    signing_salt: "`mix phx.gen.secret 32`"
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/exzeitable_web/{live,views}/.*(ex)$",
      ~r"lib/exzeitable_web/templates/.*(eex)$"
    ]
  ]

config :exzeitable, env: :dev
config :phoenix, :json_library, Jason

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
