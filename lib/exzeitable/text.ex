defmodule Exzeitable.Text do
  @moduledoc """
  Defines the behaviour for, and access to, text for the exzeitable interface.

  Default text is in Exzeitable.Text.Default
  """
  @callback new(map) :: String.t()
  @callback show(map) :: String.t()
  @callback edit(map) :: String.t()
  @callback delete(map) :: String.t()
  @callback confirm_action(map) :: String.t()
  @callback previous(map) :: String.t()
  @callback next(map) :: String.t()
  @callback search(map) :: String.t()
  @callback nothing_found(map) :: String.t()
  @callback show_field_buttons(map) :: String.t()
  @callback hide_field_buttons(map) :: String.t()
  @callback show_field(map, String.t()) :: String.t()
  @callback hide(map) :: String.t()
  @callback sort(map) :: String.t()

  @spec text(map, atom) :: String.t()
  def text(%{text: module, assigns: assigns}, function) do
    apply(module, function, [assigns])
  end

  @spec text(map, atom, String.t()) :: String.t()
  def text(%{text: module, assigns: assigns}, function, parameter) do
    apply(module, function, [assigns, parameter])
  end
end
