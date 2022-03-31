defmodule Exzeitable.HTML.ShowButton do
  @moduledoc "Show buttons and the buttons that toggle their visibility"
  use Exzeitable.HTML.Helpers

  alias Exzeitable.HTML.{Filter, Format}
  alias Exzeitable.Params

  @spec show_buttons(Params.t()) :: [any()] | String.t()
  def show_buttons(%Params{disable_hide: true}), do: ""
  def show_buttons(%Params{show_field_buttons: false}), do: ""

  def show_buttons(%Params{fields: fields} = params) do
    fields
    |> Filter.fields_where(:hidden)
    |> Enum.map(&build_show_button(params, &1))
  end

  @spec build_show_button(Params.t(), {atom, map}) :: {:safe, iolist}
  def build_show_button(%Params{} = params, {key, _value} = field) do
    name = Format.header(params, field)

    params
    |> text(:show_field, name)
    |> cont(:a,
      class: "exz-show-button",
      "phx-click": "show_column",
      "phx-value-column": key
    )
  end

  @spec build_show_hide_fields_button(Params.t()) :: {:safe, iolist} | String.t()
  def build_show_hide_fields_button(%Params{disable_hide: true}), do: ""

  def build_show_hide_fields_button(%Params{show_field_buttons: true} = params) do
    params
    |> text(:hide_field_buttons)
    |> cont(:a,
      class: "exz-info-button",
      "phx-click": "hide_buttons"
    )
  end

  def build_show_hide_fields_button(%Params{} = params) do
    params
    |> text(:show_field_buttons)
    |> cont(:a,
      class: "exz-info-button",
      "phx-click": "show_buttons"
    )
  end
end
