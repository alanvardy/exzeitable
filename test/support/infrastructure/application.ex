defmodule PhoenixWeb.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      PhoenixWeb.Repo,
      PhoenixWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
