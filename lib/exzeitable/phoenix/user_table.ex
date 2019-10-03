defmodule Exzeitable.Phoenix.UserTable do
  @moduledoc "Users site table"
  alias Exzeitable.Phoenix.Router.Helpers, as: Routes
  alias Exzeitable.Phoenix.User

  use Exzeitable,
    repo: Exzeitable.Phoenix.Repo,
    routes: Routes,
    path: :user_path,
    fields: [name: [], age: []],
    query: from(u in User)

  def render(assigns), do: ~L"<%= build_table(assigns) %>"

  def inserted_at(_socket, %{inserted_at: inserted_at}), do: nice_date(inserted_at)
  def updated_at(_socket, %{updated_at: updated_at}), do: nice_date(updated_at)

  @spec nice_date(NaiveDateTime.t()) :: String.t()
  def nice_date(datetime) do
    datetime
    |> Timex.format("%Y-%m-%d", :strftime)
    |> elem(1)
  end
end
