defmodule TestWeb.GermanText do
  @moduledoc "Custom text for the Exzeitable HTML interface"
  @behaviour Exzeitable.Text

  # Action buttons

  @impl Exzeitable.Text
  def actions(_assigns), do: "Aktionen"
  @impl Exzeitable.Text
  def new(_assigns), do: "Neu"
  @impl Exzeitable.Text
  def show(_assigns), do: "Show"
  @impl Exzeitable.Text
  def edit(_assigns), do: "Bearbeiten"
  @impl Exzeitable.Text
  def delete(_assigns), do: "Löschen"
  @impl Exzeitable.Text
  def confirm_action(_assigns), do: "Bist du sicher?"

  # Pagination

  @impl Exzeitable.Text
  def previous(_assigns), do: "Bisherige"
  @impl Exzeitable.Text
  def next(_assigns), do: "Nächster"

  # Search

  @impl Exzeitable.Text
  def search(_assigns), do: "Suche"
  @impl Exzeitable.Text
  def nothing_found(_assigns), do: "Nichts gefunden"

  # Show and hide fields

  @impl Exzeitable.Text
  def show_field_buttons(_assigns), do: "Feldschaltflächen anzeigen"
  @impl Exzeitable.Text
  def hide_field_buttons(_assigns), do: "Feldschaltflächen ausblenden"
  @impl Exzeitable.Text
  def show_field(_assigns, field), do: "Zeigen Sie #{field}"
  @impl Exzeitable.Text
  def hide(_assigns), do: "Ausblenden"
  @impl Exzeitable.Text
  def sort(_assigns), do: "Sortieren"
end
