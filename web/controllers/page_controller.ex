defmodule Flour.PageController do
  use Flour.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
