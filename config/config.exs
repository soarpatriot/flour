# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :flour,
  ecto_repos: [Flour.Repo]

config :flour, Flour.Gettext, default_locale: "zh"
  
# Configures the endpoint
config :flour, Flour.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TSh/b45/LPJ13UEMCAMXDf9+bX2y3DLlopCbqkZ8v2PN0jj4h+kWtPnBz45FUYFm",
  render_errors: [view: Flour.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Flour.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  backends: [{LoggerFileBackend, :info},
             {LoggerFileBackend, :error}]

config :logger, :info,
  path: "./log/info.log",
  level: :info

config :logger, :error,
  path: "./log/error.log",
  level: :error
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :flour,
  wechat_code_url: "https://open.weixin.qq.com/connect/oauth2/authorize",
  wechat_access_token_url: "https://api.weixin.qq.com/sns/oauth2/access_token",
  wechat_userinfo_url: "https://api.weixin.qq.com/sns/userinfo"
