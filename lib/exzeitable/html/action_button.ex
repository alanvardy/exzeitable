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

  alias Exzeitable.{Params, Text}
  alias Phoenix.HTML.Link

  @typedoc "Controller action"
  @type action :: :new | :delete | :show | :edit

  @doc "Builds an individual button, takes an atom representing the action, and the assigns map"
  @spec build(:new, map) :: {:safe, iolist}
  @spec build(action, atom, map) :: {:safe, iolist}
  def build(
        :new,
        %{
          socket: socket,
          params:
            %Params{
              parent: nil,
              routes: routes,
              path: path,
              action_buttons: action_buttons
            } = params
        }
      ) do
    if Enum.member?(action_buttons, :new) do
      [socket, :new]
      |> then(&apply(routes, path, &1))
      |> html(:new, params)
    else
      {:safe, [""]}
    end
  end

  def build(
        :new,
        %{
          socket: socket,
          params:
            %Params{
              parent: parent,
              routes: routes,
              path: path,
              action_buttons: action_buttons
            } = params
        }
      ) do
    if Enum.member?(action_buttons, :new) do
      [socket, :new, parent]
      |> then(&apply(routes, path, &1))
      |> html(:new, params)
    else
      {:safe, [""]}
    end
  end

  @doc false
  def build(
        :delete,
        entry,
        %{socket: socket, params: %Params{belongs_to: nil, routes: routes, path: path} = params}
      ) do
    [socket, :delete, entry]
    |> then(&apply(routes, path, &1))
    |> html(:delete, params)
  end

  def build(
        :delete,
        entry,
        %{socket: socket, params: %Params{routes: routes, path: path} = params}
      ) do
    [socket, :delete, parent_for(entry, params), entry]
    |> then(&apply(routes, path, &1))
    |> html(:delete, params)
  end

  def build(
        :show,
        entry,
        %{socket: socket, params: %Params{belongs_to: nil, routes: routes, path: path} = params}
      ) do
    [socket, :show, entry]
    |> then(&apply(routes, path, &1))
    |> html(:show, params)
  end

  def build(
        :show,
        entry,
        %{socket: socket, params: %Params{routes: routes, path: path} = params}
      ) do
    [socket, :show, parent_for(entry, params), entry]
    |> then(&apply(routes, path, &1))
    |> html(:show, params)
  end

  def build(
        :edit,
        entry,
        %{socket: socket, params: %Params{belongs_to: nil, routes: routes, path: path} = params}
      ) do
    [socket, :edit, entry]
    |> then(&apply(routes, path, &1))
    |> html(:edit, params)
  end

  def build(
        :edit,
        entry,
        %{socket: socket, params: %Params{routes: routes, path: path} = params}
      ) do
    [socket, :edit, parent_for(entry, params), entry]
    |> then(&apply(routes, path, &1))
    |> html(:edit, params)
  end

  # For custom actions such as archive
  def build(custom_action, entry, %{module: module, socket: socket, csrf_token: csrf_token}) do
    apply(module, custom_action, [socket, entry, csrf_token])
  end

  @spec html(String.t(), action, Params.t()) :: {:safe, iolist}
  defp html(route, :new, %Params{} = params) do
    params
    |> Text.text(:new)
    |> Link.link(to: route, class: "exz-action-new")
  end

  defp html(route, :show, %Params{} = params) do
    params
    |> Text.text(:show)
    |> Link.link(to: route, class: "exz-action-show")
  end

  defp html(route, :edit, %Params{} = params) do
    params
    |> Text.text(:edit)
    |> Link.link(to: route, class: "exz-action-edit")
  end

  defp html(route, :delete, %Params{csrf_token: csrf_token} = params) do
    params
    |> Text.text(:delete)
    |> Link.link(
      to: route,
      class: "exz-action-delete",
      method: :delete,
      "data-confirm": Text.text(params, :confirm_action),
      csrf_token: csrf_token
    )
  end

  @doc "Gets the parent that the nested resource belongs to"
  @spec parent_for(map, Params.t()) :: struct
  def parent_for(entry, %Params{belongs_to: belongs_to}) do
    case Map.get(entry, belongs_to) do
      nil -> raise "You need to select the association in :belongs_to"
      result when is_struct(result) -> result
    end
  end
end
