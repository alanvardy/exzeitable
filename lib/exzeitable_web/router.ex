defmodule ExzeitableWeb.Router do
  use ExzeitableWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ExzeitableWeb do
    pipe_through(:browser)

    resources("/users", UserController)
    resources("/posts", PostController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExzeitableWeb do
  #   pipe_through :api
  # end
end
