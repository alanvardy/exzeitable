defmodule TestWeb.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, [name: TestWeb.PubSub, adapter: Phoenix.PubSub.PG2]},
      TestWeb.Repo,
      TestWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TestWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
