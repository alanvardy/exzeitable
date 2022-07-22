defmodule Exzeitable.HTML.Format do
  @moduledoc "Formatting text"

  alias Exzeitable.{Params, Text}

  @doc """
  If function: true, will pass the entry to the function of the same name as the entry
  Else just output the field
  This function is tested but coveralls will not register it.
  """
  @spec field(map, atom, map) :: String.t() | {:safe, iolist}
  def field(entry, key, %{
        socket: socket,
        params: %Params{
          fields: fields,
          module: module,
          assigns: assigns
        }
      }) do
    if Kernel.get_in(fields, [key, :function]) do
      socket = smush_assigns_together(socket, assigns)

      apply(module, key, [socket, entry])
    else
      Map.get(entry, key, nil)
    end
    |> format_field(fields[key].formatter)
  end

  # coveralls-ignore-stop

  @doc "Will output the user supplied label or fall back on the atom"
  @spec header(Params.t(), {atom, map}) :: String.t()
  def header(_params, {_key, %{label: label}}) when is_binary(label), do: label

  def header(%Params{} = params, {:actions, _map}), do: Text.text(params, :actions)

  def header(_params, {key, _map}) do
    key
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  # We want socket.assigns, but not socket.assigns.assigns
  defp smush_assigns_together(socket, assigns) do
    socket
    |> Map.fetch!(:assigns)
    |> Map.delete(:assigns)
    |> Map.merge(assigns)
    |> then(&Map.put(socket, :assigns, &1))
  end

  @doc "The default formatter"
  @spec format_field(any) :: any
  def format_field(value), do: value

  # Called for configured formatters which can be in the format
  # {mod, fun}
  # {mod, fun, args} in which case the value is prepended to `args`

  defp format_field(value, {mod, fun}) do
    apply(mod, fun, [value])
  end

  defp format_field(value, {mod, fun, args}) do
    apply(mod, fun, [value | args])
  end
end
