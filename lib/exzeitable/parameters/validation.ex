defmodule Exzeitable.Params.Validations do
  @moduledoc "Using these instead of Keyword.fetch! to provide nice easily resolvable errors."

  alias Exzeitable.Params.ParameterError

  @doc "If you have parent then you need belongs_to, and vice versa."
  @spec paired_options(map) :: map
  def paired_options(%{"parent" => nil, "belongs_to" => nil} = session) do
    session
  end

  def paired_options(%{"parent" => nil}) do
    raise ParameterError,
      message:
        "[:parent] record needs to be defined if belongs_to is defined, i.e. Repo.find(site.id)"
  end

  def paired_options(%{"belongs_to" => nil}) do
    raise ParameterError,
      message: "[:belongs_to] needs to be defined if parent is defined, i.e. :site"
  end

  def paired_options(session) do
    session
  end

  @spec required_keys_present(map, [atom]) :: map
  def required_keys_present(params, required_keys) do
    keys = Map.keys(params)

    Enum.each(required_keys, fn required_key ->
      required_key in keys || raise(ParameterError, parameter: required_key)
    end)

    params
  end
end
