defmodule Exzeitable.Text.Default do
  @moduledoc "Default text for the Exzeitable HTML interface"
  @behaviour Exzeitable.Text

  # Action buttons

  def actions(_assigns), do: "Actions"
  def new(_assigns), do: "New"
  def show(_assigns), do: "Show"
  def edit(_assigns), do: "Edit"
  def delete(_assigns), do: "Delete"
  def confirm_action(_assigns), do: "Are you sure?"

  # Pagination

  def previous(_assigns), do: "Previous"
  def next(_assigns), do: "Next"

  # Search

  def search(_assigns), do: "Search"
  def nothing_found(_assigns), do: "Nothing found"

  # Show and hide fields

  def show_field_buttons(_assigns), do: "Show Field Buttons"
  def hide_field_buttons(_assigns), do: "Hide Field Buttons"
  def show_field(_assigns, field), do: "Show #{field}"
  def hide(_assigns), do: "hide"
  def sort(_assigns), do: "sort"
end
