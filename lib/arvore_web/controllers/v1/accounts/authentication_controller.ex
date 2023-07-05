defmodule ArvoreWeb.V1.Accounts.AuthenticationController do
  use ArvoreWeb, :controller

  alias Arvore.Accounts

  action_fallback ArvoreWeb.FallbackController

  use PhoenixSwagger
  # coveralls-ignore-start
  swagger_path :login do
    get("/api/v1/accounts/login")
    description("User Login")
    tag("Authentication")
    produces("application/json")

    parameters do
      login(:string, "user_login", "User login", required: true)
      password(:string, "password", "User password", required: true)
    end

    response(201, "Created")
    response(404, "User not found")
    response(400, "Invalid password")
  end

  # coveralls-ignore-stop
  def login(conn, params) do
    with login when not is_nil(login) <- Map.get(params, "login", nil),
         password when not is_nil(password) <- Map.get(params, "password", nil),
         {:ok, token} <- Accounts.login(login, password) do
      conn
      |> put_status(:created)
      |> json(%{"data" => %{"jwt" => token}})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end

  # coveralls-ignore-start
  def swagger_definitions do
    %{
      Login:
        swagger_schema do
          title("Login")
          description("return of login")

          properties do
            jwt(:string, "jwt", required: true)
          end

          example(%{
            data: %{
              jwt: "asdf..iweoie"
            }
          })
        end
    }
  end

  # coveralls-ignore-stop
end
