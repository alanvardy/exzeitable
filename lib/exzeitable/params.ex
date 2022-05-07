defmodule Exzeitable.Params do
  @moduledoc """
  Gets default parameters, replaces with module opts and then with the function opts.

  Validates that parameters are valid.
  """
  alias Exzeitable.HTML.Format
  alias Exzeitable.Params.Validations

  @enforce_keys [:query, :repo, :routes, :path, :fields, :module, :csrf_token]

  @type column :: atom
  @type function_name :: atom

  @type t :: %__MODULE__{
          # required
          query: Ecto.Query.t(),
          repo: module,
          routes: module,
          path: atom,
          fields: [{column, keyword}],
          module: module,
          csrf_token: String.t(),
          # optional
          order: [{:asc | :desc, column}] | nil,
          parent: struct | nil,
          belongs_to: atom | nil,
          page: pos_integer,
          count: non_neg_integer,
          list: [struct],
          search: String.t(),
          show_field_buttons: boolean,
          action_buttons: [:new | :show | :edit | :delete],
          per_page: pos_integer,
          debounce: pos_integer,
          refresh: boolean,
          disable_hide: boolean,
          pagination: [:top | :bottom],
          assigns: map,
          text: module,
          formatter: {module, function_name} | {module, function_name, list}
        }

  defstruct [
    # required
    :query,
    :repo,
    :routes,
    :path,
    :fields,
    :module,
    :csrf_token,
    # optional
    :order,
    :parent,
    :belongs_to,
    page: 1,
    count: 0,
    list: [],
    search: "",
    show_field_buttons: false,
    action_buttons: [:new, :show, :edit, :delete],
    per_page: 20,
    debounce: 300,
    refresh: false,
    disable_hide: false,
    pagination: [:top, :bottom],
    assigns: %{},
    text: Exzeitable.Text.Default,
    formatter: {Format, :format_field}
  ]

  @default_fields [
    label: nil,
    function: false,
    hidden: false,
    search: true,
    order: true,
    formatter: {Format, :format_field}
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

  @doc "Creates a new params struct, holds state for liveview"
  @spec new(keyword, keyword, atom) :: map
  def new(function_opts, module_opts, module) do
    fields =
      module_opts
      |> set_fields()
      |> Enum.map(fn {k, f} -> {k, Enum.into(f, %{})} end)

    token = Phoenix.Controller.get_csrf_token()

    module_opts
    |> Keyword.merge(function_opts)
    |> Map.new()
    |> Map.merge(%{fields: fields, module: module, csrf_token: token})
    |> Validations.paired_options()
    |> Validations.required_keys_present(@enforce_keys)
    |> then(&struct!(__MODULE__, &1))
  end
end
