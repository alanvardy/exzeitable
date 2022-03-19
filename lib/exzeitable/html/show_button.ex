defmodule Exzeitable.HTML.ShowButton do
  @moduledoc "Show buttons and the buttons that toggle their visibility"
  use Exzeitable.HTML.Helpers

  alias Exzeitable.HTML.{Filter, Format}

  @spec show_buttons(map) :: [any()] | String.t()
  def show_buttons(%{disable_hide: true}), do: ""
  def show_buttons(%{show_field_buttons: false}), do: ""

  def show_buttons(assigns) do
    assigns
    |> Map.fetch!(:fields)
    |> Filter.fields_where(:hidden)
    |> Enum.map(fn field -> build_show_button(assigns, field) end)
  end

  def build_show_button(assigns, {key, _value} = field) do
    name = Format.header(assigns, field)

    assigns
    |> text(:show_field, name)
    |> cont(:a,
      class: "exz-show-button",
      "phx-click": "show_column",
      "phx-value-column": key
    )
  end

  @spec build_show_hide_fields_button(map) :: {:safe, iolist} | String.t()
  def build_show_hide_fields_button(%{disable_hide: true}), do: ""

  def build_show_hide_fields_button(%{show_field_buttons: true} = assigns) do
    assigns
    |> text(:hide_field_buttons)
    |> cont(:a,
      class: "exz-info-button",
      "phx-click": "hide_buttons"
    )
  end

  def build_show_hide_fields_button(assigns) do
    assigns
    |> text(:show_field_buttons)
    |> cont(:a,
      class: "exz-info-button",
      "phx-click": "show_buttons"
    )
  end
end
