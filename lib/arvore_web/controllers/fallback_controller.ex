defmodule ArvoreWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, response) when response in [{:authorized, false}, {:error, :unauthorized}] do
    render_error(conn, :unauthorized, "Not Authorized")
  end

  def call(conn, {:error, :not_found}) do
    render_error(conn, :not_found, "Not found")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ArvoreWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, message}) do
    render_error(conn, :unprocessable_entity, message)
  end

  defp render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(ArvoreWeb.ErrorView)
    |> render("default_error.json", message: message)
  end
end
