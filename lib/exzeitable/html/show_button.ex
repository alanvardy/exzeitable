defmodule Exzeitable.HTML.ShowButton do
  @moduledoc "Show buttons and the buttons that toggle their visibility"
  alias Exzeitable.HTML.{Filter, Format, Helpers}
  alias Exzeitable.{HTML, Params, Text}

  @doc "Returns HTML for all the show column buttons that should be visible"
  @spec show_buttons(Params.t()) :: [{:safe, iolist}]
  def show_buttons(%Params{disable_hide: true}), do: [{:safe, [""]}]
  def show_buttons(%Params{show_field_buttons: false}), do: [{:safe, [""]}]

  def show_buttons(%Params{fields: fields} = params) do
    fields
    |> Filter.fields_where(:hidden)
    |> Enum.map(&build_show_button(params, &1))
  end

  @doc "Returns HTML for the show column button"
  @spec build_show_button(Params.t(), {atom, map}) :: {:safe, iolist}
  def build_show_button(%Params{} = params, {key, _value} = field) do
    name = Format.header(params, field)

    params
    |> Text.text(:show_field, name)
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-show-button"),
      "phx-click": "show_column",
      "phx-value-column": key
    )
  end

  @doc """
    Button for showing and hiding the buttons that show/hide fields
  """
  @spec build_show_hide_fields_button(Params.t()) :: {:safe, iolist}
  def build_show_hide_fields_button(%Params{disable_hide: true}), do: {:safe, [""]}

  def build_show_hide_fields_button(%Params{show_field_buttons: true} = params) do
    params
    |> Text.text(:hide_field_buttons)
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-info-button"),
      "phx-click": "hide_buttons"
    )
  end

  def build_show_hide_fields_button(%Params{} = params) do
    params
    |> Text.text(:show_field_buttons)
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-info-button"),
      "phx-click": "show_buttons"
    )
  end
end
