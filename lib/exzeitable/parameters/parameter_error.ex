defmodule Exzeitable.Params.ParameterError do
  @moduledoc "An exception for missing or bad parameters"
  defexception [:parameter, :message]

  @doc "Sets the correct message based on the missing parameter"
  @impl true
  def message(%{parameter: :repo}) do
    "You need to set the repo, i.e. MyApp.Repo"
  end

  def message(%{parameter: :query}) do
    "You need to set the query, i.e. from(s in Site, select: [:id, :number, :address])"
  end

  def message(%{parameter: :routes}) do
    "You need to set the routes module, i.e. MyAppWeb.Router.Helpers"
  end

  def message(%{parameter: :path}) do
    "You need to set the path, i.e. :user_path"
  end

  def message(%{parameter: parameter}) do
    "Required parameter #{inspect(parameter)} is not defined"
  end

  def message(%{message: message}) do
    message
  end
end
