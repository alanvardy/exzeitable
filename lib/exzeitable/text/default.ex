defmodule Exzeitable.Text.Default do
  @moduledoc "Default text for the Exzeitable HTML interface"
  @behaviour Exzeitable.Text

  # Action buttons

  @impl Exzeitable.Text
  def actions(_assigns), do: "Actions"
  @impl Exzeitable.Text
  def new(_assigns), do: "New"
  @impl Exzeitable.Text
  def show(_assigns), do: "Show"
  @impl Exzeitable.Text
  def edit(_assigns), do: "Edit"
  @impl Exzeitable.Text
  def delete(_assigns), do: "Delete"
  @impl Exzeitable.Text
  def confirm_action(_assigns), do: "Are you sure?"

  # Pagination

  @impl Exzeitable.Text
  def previous(_assigns), do: "Previous"
  @impl Exzeitable.Text
  def next(_assigns), do: "Next"

  # Search

  @impl Exzeitable.Text
  def search(_assigns), do: "Search"
  @impl Exzeitable.Text
  def nothing_found(_assigns), do: "Nothing found"

  # Show and hide fields

  @impl Exzeitable.Text
  def show_field_buttons(_assigns), do: "Show Field Buttons"
  @impl Exzeitable.Text
  def hide_field_buttons(_assigns), do: "Hide Field Buttons"
  @impl Exzeitable.Text
  def show_field(_assigns, field), do: "Show #{field}"
  @impl Exzeitable.Text
  def hide(_assigns), do: "hide"
  @impl Exzeitable.Text
  def sort(_assigns), do: "sort"
end
