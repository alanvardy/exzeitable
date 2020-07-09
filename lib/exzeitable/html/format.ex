defmodule Exzeitable.HTML.Format do
  @moduledoc "Formatting text"
  use Exzeitable.HTML.Helpers

  @doc """
  If function: true, will pass the entry to the function of the same name as the entry
  Else just output the field
  This function is tested but coveralls will not register it.
  """
  @spec field(map, atom, map) :: String.t() | {:safe, iolist}
  def field(entry, key, %{
        socket: socket,
        fields: fields,
        module: module,
        assigns: assigns
      }) do
    if Kernel.get_in(fields, [key, :function]) do
      socket = smush_assigns_together(socket, assigns)

      apply(module, key, [socket, entry])
    else
      Map.get(entry, key, nil)
    end
  end

  # coveralls-ignore-stop

  @doc "Will output the user supplied label or fall back on the atom"
  @spec header(map, {atom, map}) :: String.t()
  def header(_assigns, {_key, %{label: label}}) when is_binary(label), do: label

  def header(assigns, {:actions, _map}), do: text(assigns, :actions)

  def header(_assigns, {key, _map}) do
    key
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  # We want socket.assigns, but not socket.assigns.assigns
  defp smush_assigns_together(socket, assigns) do
    assigns =
      socket.assigns
      |> Map.delete(:assigns)
      |> Map.merge(assigns)

    Map.put(socket, :assigns, assigns)
  end
end
