defmodule Exzeitable.HTML do
  @moduledoc """
    For building the HTML tags themselves, check CSS.md for information on applying CSS classes.
  """

  use Phoenix.HTML
  alias Exzeitable.HTML.{ActionButton, Pagination, Search, ShowButton, Table}

  @doc "Root function for building the HTML table"
  # onclick="" is for iOS support
  @spec build(map) :: {:safe, iolist}
  def build(assigns) do
    search_box = Search.build(assigns)
    new_button = ActionButton.build(:new, assigns)
    show_buttons = ShowButton.show_buttons(assigns)
    pagination = Pagination.build(assigns)
    top_pagination = maybe_render_pagination(:top, assigns, pagination)
    bottom_pagination = maybe_render_pagination(:bottom, assigns, pagination)
    show_hide_fields = ShowButton.build_show_hide_fields_button(assigns)
    table = Table.build(assigns)
    bottom_buttons = div_wrap([new_button, show_hide_fields])

    top_navigation =
      div_wrap(
        [
          div_wrap([top_pagination, new_button, show_hide_fields], "exz-pagination-wrapper"),
          search_box
        ],
        "exz-row"
      )

    content_tag(
      :div,
      [
        top_navigation,
        show_buttons,
        table,
        show_buttons,
        bottom_buttons,
        bottom_pagination
      ],
      class: "outer-wrapper",
      onclick: ""
    )
  end

  defp div_wrap(content, class \\ "") do
    content_tag(:div, content, class: class)
  end

  defp maybe_render_pagination(position, %{pagination: positions}, pagination) do
    if position in positions do
      pagination
    else
      ""
    end
  end
end
