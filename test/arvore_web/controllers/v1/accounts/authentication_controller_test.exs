defmodule ArvoreWeb.V1.Accounts.AuthenticationControllerTest do
  use ArvoreWeb.ConnCase, async: true

  alias Arvore.Accounts

  @valid_attrs %{
    "name" => "name",
    "login" => "login",
    "email" => "email@teste.com",
    "password" => "password",
    "type" => "admin"
  }

  describe "login user" do
    test "return json with jwt when user data is valid", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      response =
        conn
        |> post(
          Routes.authentication_path(conn, :login, %{
            "login" => user.login,
            "password" => @valid_attrs["password"]
          })
        )
        |> json_response(:created)

      assert %{"jwt" => _jwt} = response
    end

    test "return error when user password is invalid", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      response =
        conn
        |> post(
          Routes.authentication_path(conn, :login, %{"login" => user.login, "password" => "teste"})
        )
        |> json_response(:unauthorized)

      assert response["error"] == "Invalid password"
    end

    test "return error when user login not found", %{conn: conn} do
      response =
        conn
        |> post(
          Routes.authentication_path(conn, :login, %{"login" => "teste", "password" => "teste"})
        )
        |> json_response(:not_found)

      assert response["error"] == "User not found"
    end
  end
end
