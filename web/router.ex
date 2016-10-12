defmodule Flour.Router do
  use Flour.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Flour do
    pipe_through :browser # Use the default browser stack
    get "/posts/top",  PostController, :top
    resources "/posts", PostController 
    get "/posts/:id/flower",  PostController, :flower
    post "/posts/:id/comment",  PostController, :comment
    resources "/photos", PhotoController 
    get "/", PageController, :index
    get "/sign", PageController, :sign
  end

  # Other scopes may use custom stacks.
  scope "/api", Flour do
    pipe_through :api
    get "/sign", WechatController, :sign
  end
end
