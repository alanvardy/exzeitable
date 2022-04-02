defmodule Exzeitable.Text do
  @moduledoc """
  Defines the behaviour for, and access to, text for the exzeitable interface.

  Default text is in Exzeitable.Text.Default
  """

  alias Exzeitable.Params

  @callback actions(map) :: String.t()
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

  @doc "Call the text function with assigns"
  @spec text(Params.t(), atom) :: String.t()
  def text(%Params{text: module, assigns: assigns}, function) do
    apply(module, function, [assigns])
  end

  @doc "Call the text function with assigns and an extra parameter"
  @spec text(Params.t(), atom, String.t()) :: String.t()
  def text(%Params{text: module, assigns: assigns}, function, parameter) do
    apply(module, function, [assigns, parameter])
  end
end
