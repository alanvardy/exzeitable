defmodule Exzeitable.HTML.ActionButton do
  @moduledoc """
  For the actions buttons such as :new, :edit etc, as well as custom buttons.

  Custom buttons can be added to the list in :action_buttons

  ## Example

  ```elixir
    action_buttons: [:new, :edit, :super_cool_custom_action]
  ```

  You can then define the function called for that action in the module where the table is defined.
  Don't forget to add your csrf_token.

  ```elixir
    def super_cool_custom_action(socket, item, csrf_token) do
      link "SUPER AWESOME", to: Routes.super_cool_path(socket, :custom_action, item), "data-confirm": "Are you sure?", csrf_token: csrf_token
    end
  ```
  """
  use Exzeitable.HTML.Helpers

  @type action :: :new | :delete | :show | :edit

  @doc "Builds an individual button, takes an atom representing the action, and the assigns map"
  @spec build(:new, map) :: {:safe, iolist}
  @spec build(action, atom, map) :: {:safe, iolist}
  def build(:new, %{parent: nil} = assigns) do
    %{
      socket: socket,
      routes: routes,
      path: path,
      action_buttons: action_buttons
    } = assigns

    if Enum.member?(action_buttons, :new) do
      apply(routes, path, [socket, :new])
      |> html(:new, assigns)
    else
      ""
    end
  end

  def build(:new, %{parent: parent} = assigns) do
    %{
      socket: socket,
      routes: routes,
      path: path,
      action_buttons: action_buttons
    } = assigns

    if Enum.member?(action_buttons, :new) do
      apply(routes, path, [socket, :new, parent])
      |> html(:new, assigns)
    else
      ""
    end
  end

  def build(:delete, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :delete, entry])
    |> html(:delete, assigns)
  end

  def build(:delete, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    params = [socket, :delete, parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html(:delete, assigns)
  end

  def build(:show, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :show, entry])
    |> html(:show, assigns)
  end

  def build(:show, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    params = [socket, :show, parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html(:show, assigns)
  end

  def build(:edit, entry, %{belongs_to: nil} = assigns) do
    %{socket: socket, routes: routes, path: path} = assigns

    apply(routes, path, [socket, :edit, entry])
    |> html(:edit, assigns)
  end

  def build(:edit, entry, assigns) do
    %{socket: socket, routes: routes, path: path} = assigns
    params = [socket, :edit, parent_for(entry, assigns), entry]

    apply(routes, path, params)
    |> html(:edit, assigns)
  end

  # For custom actions such as archive
  def build(custom_action, entry, %{module: module, socket: socket, csrf_token: csrf_token}) do
    apply(module, custom_action, [socket, entry, csrf_token])
  end

  @spec html(String.t(), action, map) :: {:safe, iolist}
  defp html(route, :new, assigns) do
    assigns
    |> text(:new)
    |> link(to: route, class: "exz-action-new")
  end

  defp html(route, :show, assigns) do
    assigns
    |> text(:show)
    |> link(to: route, class: "exz-action-show")
  end

  defp html(route, :edit, assigns) do
    assigns
    |> text(:edit)
    |> link(to: route, class: "exz-action-edit")
  end

  defp html(route, :delete, %{csrf_token: csrf_token} = assigns) do
    assigns
    |> text(:delete)
    |> link(
      to: route,
      class: "exz-action-delete",
      method: :delete,
      "data-confirm": text(assigns, :confirm_action),
      csrf_token: csrf_token
    )
  end

  # Gets the parent that the nested resource belongs to
  def parent_for(entry, %{belongs_to: belongs_to}) do
    case Map.get(entry, belongs_to) do
      nil -> raise "You need to select the association in :belongs_to"
      result -> result
    end
  end
end
