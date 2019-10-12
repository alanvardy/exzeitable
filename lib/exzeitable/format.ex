defmodule Exzeitable.Format do
  @moduledoc "Formatting text"

  @doc """
  If function: true, will pass the entry to the function of the same name as the entry
  Else just output the field
  This function is tested but coveralls will not register it.
  """

  @spec field(map, atom, map) :: String.t() | {:safe, iolist}
  def field(entry, key, %{socket: socket, fields: fields, module: module}) do
    if Kernel.get_in(fields, [key, :function]) do
      apply(module, key, [socket, entry])
    else
      Map.get(entry, key, nil)
    end
  end

  # coveralls-ignore-stop

  @doc "Will output the user supplied label or fall back on the atom"
  @spec header({atom, map}) :: String.t()
  def header({_key, %{label: label}}) when is_binary(label), do: label

  def header({key, _map}) do
    key
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
