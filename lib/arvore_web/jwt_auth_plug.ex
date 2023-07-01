defmodule ArvoreWeb.JwtAuthPlug do
  @moduledoc """
  Plug for jwt authorization
  """
  import Plug.Conn
  alias Arvore.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with token when not is_nil(token) <- jwt_from_header(conn),
         {:ok, claims} <- Accounts.validate_token(token) do
      success(conn, claims, token)
    else
      {:error, error} -> forbidden(conn, error)
      _ -> forbidden(conn, "Forbidden")
    end
  end

  defp jwt_from_header(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> get_token()
  end

  defp get_token(["Bearer " <> token]), do: token
  defp get_token(_), do: nil

  defp success(conn, claims, token) do
    conn
    |> assign(:claims, claims)
    |> assign(:jwt, token)
  end

  defp forbidden(conn, error) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.put_view(ArvoreWeb.ErrorView)
    |> Phoenix.Controller.render("default_error.json", %{message: error})
    |> halt
  end
end
