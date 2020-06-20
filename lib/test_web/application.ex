defmodule Exzeitable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Phoenix.PubSub, [name: Exzeitable.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start the Ecto repository
      TestWeb.Repo,
      # Start the endpoint when the application starts
      TestWeb.Endpoint
      # Starts a worker by calling: Exzeitable.Worker.start_link(arg)
      # {Exzeitable.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exzeitable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
