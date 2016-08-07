use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :flour, Flour.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :flour, Flour.Endpoint,
  live_reload: [
    patterns: [
      # ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :flour, Flour.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "22143521",
  database: "flour_dev",
  hostname: "localhost",
  pool_size: 10

config :flour,
  wechat_appid: "wx5940611bb6faccc3",
  wechat_secret: "655870e4c49d7e85b6b2222a1ee470eb"
 
config :arc,
  asset_host: "http://localhost:4000"

config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

config :phoenix_session_redis, :config,
  name: :redis_sessions,            # Pool name
  pool: [
    size: 2,                        # Number of worker
    max_overflow: 5,                # Max Additional worker
    name: {:local, :redis_sessions} # First is determination where the pool is run
                                    # Second is unique pool name
  ],
  redis: [                          # Worker arguments
    host: '127.0.0.1',              # Redis host(it is char list !)
    port: 6379,                     # Redis port
  ]
