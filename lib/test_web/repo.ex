defmodule TestWeb.Repo do
  @moduledoc false

  @doc false
  use Ecto.Repo,
    otp_app: :exzeitable,
    adapter: Ecto.Adapters.Postgres
end
