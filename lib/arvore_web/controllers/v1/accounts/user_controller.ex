defmodule ArvoreWeb.V1.Accounts.UserController do
  use ArvoreWeb, :controller

  alias Arvore.Accounts
  alias Arvore.Accounts.User

  action_fallback ArvoreWeb.FallbackController

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      %User{} = user -> render(conn, "show.json", user: user)
      nil -> {:error, :not_found}
    end
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def update(conn, user_params) do
    with %User{} = user <- Accounts.get_user(user_params["id"]),
         {:ok, user} <- Accounts.update_user(user, user_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    else
      nil -> {:error, :not_found}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def delete(conn, %{"id" => id}) do
    with %User{} = user <- Accounts.get_user(id),
         {:ok, user} <- Accounts.delete_user(user) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    else
      nil -> {:error, :not_found}
    end
  end

  def me(%{assigns: %{claims: claims}} = conn, _param) do
    case Accounts.get_user(claims["sub"]) do
      %User{} = user ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)

      nil ->
        {:error, :not_found}
    end
  end
end
