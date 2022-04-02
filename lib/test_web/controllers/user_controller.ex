defmodule TestWeb.UserController do
  use TestWeb, :controller

  alias TestWeb.{Query, User}

  @type conn :: Plug.Conn.t()

  @spec index(conn, map) :: conn
  def index(conn, _params) do
    users = Query.list_users()
    render(conn, "index.html", users: users)
  end

  @spec new(conn, map) :: conn
  def new(conn, _params) do
    changeset = Query.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(conn, map) :: conn
  def create(conn, %{"user" => user_params}) do
    case Query.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec show(conn, map) :: conn
  def show(conn, %{"id" => id}) do
    user = Query.get_user!(id)
    render(conn, "show.html", user: user)
  end

  @spec edit(conn, map) :: conn
  def edit(conn, %{"id" => id}) do
    user = Query.get_user!(id)
    changeset = Query.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  @spec update(conn, map) :: conn
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Query.get_user!(id)

    case Query.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  @spec delete(conn, map) :: conn
  def delete(conn, %{"id" => id}) do
    user = Query.get_user!(id)
    {:ok, _user} = Query.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  # For testing formatter configuration
  @spec formatted_index(conn, map) :: conn
  def formatted_index(conn, _params), do: render(conn, "formatted_index.html")
end
