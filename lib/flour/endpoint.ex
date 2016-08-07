defmodule Flour.Endpoint do
  use Phoenix.Endpoint, otp_app: :flour

  socket "/socket", Flour.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :flour, gzip: false,
    only: ~w(uploads css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
 # plug Plug.Session,
  #  store: :cookie,
  #  key: "_flour_key",
  #  signing_salt: "3usE37lQ"

  plug Plug.Session,
    store: :redis,                           # Plug.Session.REDIS module
    key: "_flour_key",                       # Cookie name
    table: :redis_sessions,                  # Pool name
    ttl:     1 * 60 * 60,                    # Redis expiration
    max_age: 1 * 60 * 60                     # Cookie expiration

  plug Flour.Router
	# plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  # plug Plug.Parsers,
  #  parsers: [:urlencoded, :multipart, :json],
  #  pass: ["*/*"],
  #  json_decoder: Poison
end
