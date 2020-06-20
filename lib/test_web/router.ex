defmodule TestWeb.Router do
  @moduledoc false
  use TestWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TestWeb do
    pipe_through(:browser)

    get("/", PostController, :index)
    resources("/users", UserController)
    get("/posts/no_action_buttons", PostController, :no_action_buttons)
    resources("/posts", PostController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestWeb do
  #   pipe_through :api
  # end
end
