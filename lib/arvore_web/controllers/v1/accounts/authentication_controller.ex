defmodule ArvoreWeb.V1.Accounts.AuthenticationController do
  use ArvoreWeb, :controller

  alias Arvore.Accounts

  action_fallback ArvoreWeb.FallbackController

  def login(conn, params) do
    with login when not is_nil(login) <- Map.get(params, "login", nil),
         password when not is_nil(password) <- Map.get(params, "password", nil),
         {:ok, token} <- Accounts.login(login, password) do
      conn
      |> put_status(:created)
      |> json(%{"jwt" => token})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end
end
