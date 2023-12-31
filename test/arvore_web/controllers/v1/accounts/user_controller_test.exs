defmodule ArvoreWeb.V1.Accounts.UserControllerTest do
  use ArvoreWeb.ConnCase, async: true

  import Mock

  alias Arvore.Accounts

  @valid_attrs %{
    "name" => "name",
    "login" => "login",
    "email" => "email@teste.com",
    "password" => "password",
    "type" => "admin"
  }

  setup_with_mocks([{ArvoreWeb.JwtAuthPlug, [], [call: fn conn, _ -> conn end]}]) do
    :ok
  end

  describe "list users" do
    test "return json list of users", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> get(Routes.user_path(conn, :index))
        |> json_response(:ok)

      [response_user] = response["data"]

      assert response_user == %{
               "email" => user.email,
               "id" => response_user["id"],
               "login" => user.login,
               "name" => user.name,
               "type" => user.type
             }
    end

    test "return json empty list if has no user", %{conn: conn} do
      response =
        conn
        |> get(Routes.user_path(conn, :index))
        |> json_response(:ok)

      assert [] == response["data"]
    end
  end

  describe "get user" do
    test "return json user by id", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> get(Routes.user_path(conn, :show, user.id))
        |> json_response(:ok)

      assert response["data"] == %{
               "email" => user.email,
               "id" => response["data"]["id"],
               "login" => user.login,
               "name" => user.name,
               "type" => user.type
             }
    end

    test "return not found error message when id not exists", %{conn: conn} do
      response =
        conn
        |> get(Routes.user_path(conn, :show, 1))
        |> json_response(:not_found)

      assert response["error"] == "Not found"
    end
  end

  describe "create user" do
    test "return json user when create", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create, @valid_attrs))
        |> json_response(:created)

      user = Accounts.get_user(response["data"]["id"])

      assert response["data"] == %{
               "email" => user.email,
               "id" => response["data"]["id"],
               "login" => user.login,
               "name" => user.name,
               "type" => user.type
             }
    end

    test "return json errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{}

      response =
        conn
        |> post(Routes.user_path(conn, :create, invalid_attrs))
        |> json_response(:unprocessable_entity)

      assert response == %{
               "errors" => %{
                 "login" => ["can't be blank"],
                 "name" => ["can't be blank"],
                 "email" => ["can't be blank"],
                 "password" => ["can't be blank"],
                 "type" => ["can't be blank"]
               }
             }
    end
  end

  describe "update user" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "return succes when data is valid", %{conn: conn, user: user} do
      response =
        conn
        |> put(Routes.user_path(conn, :update, user.id, @valid_attrs))
        |> json_response(:ok)

      assert response["data"] == %{
               "email" => @valid_attrs["email"],
               "id" => response["data"]["id"],
               "login" => @valid_attrs["login"],
               "name" => @valid_attrs["name"],
               "type" => @valid_attrs["type"]
             }
    end

    test "return json errors when user not found", %{conn: conn} do
      response =
        conn
        |> put(Routes.user_path(conn, :update, 2, %{}))
        |> json_response(:not_found)

      assert response == %{"error" => "Not found"}
    end

    test "return json errors when data is invalid", %{conn: conn, user: user} do
      invalid_attrs = %{"name" => nil}

      response =
        conn
        |> put(Routes.user_path(conn, :update, user.id, invalid_attrs))
        |> json_response(:unprocessable_entity)

      assert response == %{"errors" => %{"name" => ["can't be blank"]}}
    end
  end

  describe "delete user" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "return json user when deleted", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user.id))
      assert response(conn, :no_content)

      assert nil == Accounts.get_user(user.id)
    end

    test "return not found error message when id not exists", %{conn: conn} do
      response =
        conn
        |> delete(Routes.user_path(conn, :delete, 1))
        |> json_response(:not_found)

      assert response["error"] == "Not found"
    end
  end

  describe "route me" do
    test "return json user by logged user", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> assign(:claims, %{"sub" => user.id})
        |> assign(:jwt, "token")

      response =
        conn
        |> get(Routes.user_path(conn, :me))
        |> json_response(:ok)

      assert response["data"] == %{
               "email" => user.email,
               "id" => user.id,
               "login" => user.login,
               "name" => user.name,
               "type" => user.type
             }
    end

    test "return not found error", %{conn: conn} do
      conn =
        conn
        |> assign(:claims, %{"sub" => 1})
        |> assign(:jwt, "token")

      response =
        conn
        |> get(Routes.user_path(conn, :me))
        |> json_response(:not_found)

      assert response == %{"error" => "Not found"}
    end
  end
end
