defmodule TestWeb.GermanText do
  @moduledoc "Custom text for the Exzeitable HTML interface"
  @behaviour Exzeitable.Text

  # Action buttons

  def actions(_assigns), do: "Aktionen"
  def new(_assigns), do: "Neu"
  def show(_assigns), do: "Show"
  def edit(_assigns), do: "Bearbeiten"
  def delete(_assigns), do: "Löschen"
  def confirm_action(_assigns), do: "Bist du sicher?"

  # Pagination

  def previous(_assigns), do: "Bisherige"
  def next(_assigns), do: "Nächster"

  # Search

  def search(_assigns), do: "Suche"
  def nothing_found(_assigns), do: "Nichts gefunden"

  # Show and hide fields

  def show_field_buttons(_assigns), do: "Feldschaltflächen anzeigen"
  def hide_field_buttons(_assigns), do: "Feldschaltflächen ausblenden"
  def show_field(_assigns, field), do: "Zeigen Sie #{field}"
  def hide(_assigns), do: "Ausblenden"
  def sort(_assigns), do: "Sortieren"
end
