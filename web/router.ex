defmodule Flour.Router do
  use Flour.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Flour do
    pipe_through :browser # Use the default browser stack
    resources "/posts", PostController 
    resources "/photos", PhotoController 
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Flour do
  #   pipe_through :api
  # end
end
