defmodule Exzeitable.Format do
  @moduledoc "For text management of "
  @spec field(map, atom, map) :: String.t() | {:safe, iolist}
  def field(entry, key, %{socket: socket, fields: fields, module: module}) do
    if Kernel.get_in(fields, [key, :function]) do
      apply(module, key, [socket, entry])
    else
      Map.get(entry, key, nil)
    end
  end

  @spec header({atom, map}) :: String.t()
  def header({_key, %{label: label}}) when is_binary(label), do: label

  def header({key, _map}) do
    key
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
