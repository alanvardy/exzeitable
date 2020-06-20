defmodule Exzeitable.Parameters do
  @moduledoc """
  Gets default parameters, replaces with module opts and then with the function opts.

  Validates that parameters are valid.
  """
  alias Exzeitable.Parameters.Validation

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
    # coveralls-ignore-start
    # Required for basic functionality
    query = Keyword.get(module_opts, :query)
    repo = Keyword.get(module_opts, :repo)
    routes = Keyword.get(module_opts, :routes)
    path = Keyword.get(module_opts, :path)
    fields = set_fields(module_opts)

    # Optional
    action_buttons = Keyword.get(module_opts, :action_buttons, [:new, :show, :edit, :delete])
    belongs_to = Keyword.get(module_opts, :belongs_to)
    per_page = Keyword.get(module_opts, :per_page, 20)
    parent = Keyword.get(module_opts, :parent)
    debounce = Keyword.get(module_opts, :debounce, 300)
    refresh = Keyword.get(module_opts, :refresh, false)

    %{
      # Required for basic functionality
      "query" => Keyword.get(function_opts, :query, query),
      "repo" => Keyword.get(function_opts, :repo, repo),
      "routes" => Keyword.get(function_opts, :routes, routes),
      "path" => Keyword.get(function_opts, :path, path),
      # Optional
      "action_buttons" => Keyword.get(function_opts, :action_buttons, action_buttons),
      "belongs_to" => Keyword.get(function_opts, :belongs_to, belongs_to),
      "per_page" => Keyword.get(function_opts, :per_page, per_page),
      "parent" => Keyword.get(function_opts, :parent, parent),
      "assigns" => Keyword.get(function_opts, :assigns, %{}),
      "debounce" => debounce,
      "refresh" => refresh,
      "fields" => fields |> Enum.map(fn {k, f} -> {k, Enum.into(f, %{})} end),
      "module" => calling_module,
      "page" => 1,
      "order" => nil,
      "count" => 0,
      "search" => "",
      "show_field_buttons" => false,
      "csrf_token" => Phoenix.Controller.get_csrf_token()
    }
    |> Validation.required_options()
    |> Validation.paired_options()
  end
end
