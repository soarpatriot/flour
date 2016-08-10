defmodule Flour.PageController do
  use Flour.Web, :controller
  require Logger
  def index(conn, _params) do
    Logger.error("page")
    render conn, "index.html"
  end
end
