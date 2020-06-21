defmodule Exzeitable.Parameters do
  @moduledoc """
  Gets default parameters, replaces with module opts and then with the function opts.

  Validates that parameters are valid.
  """
  alias Exzeitable.Parameters.{ParameterError, Validation}

  @parameters %{
    query: %{required: true},
    repo: %{required: true},
    routes: %{required: true},
    path: %{required: true},
    action_buttons: %{default: [:new, :show, :edit, :delete]},
    belongs_to: %{default: nil},
    per_page: %{default: 20},
    debounce: %{default: 300},
    refresh: %{default: false},
    parent: %{default: nil},
    assigns: %{default: %{}}
  }

  @default_fields [
    label: nil,
    function: false,
    hidden: false,
    search: true,
    order: true
  ]

  @virtual_fields [
    function: true,
    search: false,
    order: false
  ]

  @doc "Gets fields from options and merges it into the defaults"
  @spec set_fields(keyword) :: [any]
  def set_fields(opts) do
    opts
    |> Keyword.get(:fields, [])
    |> Enum.map(fn {key, field} -> {key, merge_fields(field)} end)
  end

  # If virtual: true, a number of other options have to be overridden
  @spec merge_fields(keyword) :: keyword
  defp merge_fields(field) do
    if Keyword.get(field, :virtual) do
      @default_fields
      |> Keyword.merge(field)
      |> Keyword.merge(@virtual_fields)
    else
      Keyword.merge(@default_fields, field)
    end
  end

  @spec process(keyword, keyword, atom) :: map
  def process(function_opts, module_opts, calling_module) do
    fields = set_fields(module_opts)

    @parameters
    |> Map.keys()
    |> Enum.map(&get_key_value_pair(&1, function_opts, module_opts))
    |> Enum.into(%{})
    |> Map.merge(%{
      "fields" => Enum.map(fields, fn {k, f} -> {k, Enum.into(f, %{})} end),
      "module" => calling_module,
      "page" => 1,
      "order" => nil,
      "count" => 0,
      "search" => "",
      "show_field_buttons" => false,
      "csrf_token" => Phoenix.Controller.get_csrf_token()
    })
    |> Validation.paired_options()
  end

  defp get_key_value_pair(parameter, function_opts, module_opts) do
    key = Atom.to_string(parameter)
    function = Keyword.get(function_opts, parameter)
    module = Keyword.get(module_opts, parameter)
    default = get_in(@parameters, [parameter, :default])
    is_required? = get_in(@parameters, [parameter, :required]) || false

    case {function, module, default, is_required?} do
      {nil, nil, _, true} -> raise ParameterError, parameter: parameter
      {nil, nil, default_value, false} -> {key, default_value}
      {nil, module_value, _, _} -> {key, module_value}
      {function_value, _, _, _} -> {key, function_value}
    end
  end
end
