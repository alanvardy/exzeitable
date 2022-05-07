defmodule TestWeb.Router do
  @moduledoc false
  use TestWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug :put_root_layout, {TestWeb.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TestWeb do
    pipe_through(:browser)

    get("/", PostController, :index)
    get("/beitrage", BeitrageController, :index)
    get("/users/formatted", UserController, :formatted_index)
    resources("/users", UserController)
    get("/posts/no_action_buttons", PostController, :no_action_buttons)
    get("/posts/disable_hide", PostController, :disable_hide)
    get("/posts/no_pagination", PostController, :no_pagination)
    resources("/posts", PostController)

    live_session(:default) do
      live "/live_session_users", UserTable
    end
  end
end
