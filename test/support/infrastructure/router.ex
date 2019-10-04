defmodule PhoenixWeb.Router do
  use PhoenixWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", PhoenixWeb do
    get("/posts", PageController, :posts)
    get("/users", PageController, :users)
  end
end
