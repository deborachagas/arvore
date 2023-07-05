defmodule ArvoreWeb.V1.Accounts.UserController do
  use ArvoreWeb, :controller

  alias Arvore.Accounts
  alias Arvore.Accounts.User

  action_fallback ArvoreWeb.FallbackController

  use PhoenixSwagger

  # coveralls-ignore-start
  swagger_path :index do
    get("/api/v1/accounts/users")
    description("List users")
    tag("User")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Users))
  end

  swagger_path :show do
    get("/api/v1/accounts/users/{id}")
    description("Get user by id")
    tag("User")

    parameters do
      id(:integer, 1, "User ID", required: true)
    end

    produces("application/json")
    response(200, "Ok", Schema.ref(:User))
    response(404, "Not found")
  end

  swagger_path :create do
    post("/api/v1/accounts/users")
    description("Create user")
    tag("User")

    parameters do
      name(:string, "User Name", "Name of user", required: true)
      login(:string, "user_login", "Login of user", required: true)
      email(:string, "user@email.com", "Email of user", required: true)
      password(:string, "password", "Login of user", required: true)
      type(:string, "admin", "Typ of user", required: true)
      entity_id(:integer, 1, "Entity from user")
    end

    response(201, "Created", Schema.ref(:User))
    response(422, "Unproccessable user")
  end

  swagger_path :update do
    put("/api/v1/accounts/users/{id}")
    description("Update user")
    tag("User")

    parameters do
      id(:string, "User id", "ID of user", required: true)
      name(:string, "User Name", "Name of user")
      login(:string, "user_login", "Login of user")
      email(:string, "user@email.com", "Email of user")
      password(:string, "password", "Login of user")
      type(:string, "admin or entity", "Typ of user")
      entity_id(:integer, 1, "Entity from user")
    end

    response(200, "Success", Schema.ref(:User))
    response(404, "Not found")
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/v1/accounts/users/{id}")
    description("Delete user")
    tag("User")

    parameters do
      id(:integer, 1, "User ID", required: true)
    end

    response(204, "No Content")
    response(404, "Not found")
  end

  swagger_path :me do
    get("/api/v1/accounts/users/me")
    description("Information from authenticated user")
    tag("User")
    response(200, "Success", Schema.ref(:User))
    response(404, "Not found")
  end

  # coveralls-ignore-stop
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
         {:ok, _user} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
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

  # coveralls-ignore-start
  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            id(:integer, "User id", required: true)
            name(:string, "User name", required: true)
            login(:string, "User login", required: true)
            type(:string, "Type of user", required: true)
            email(:string, "Email of user", required: true)
            entity_id(:integer, "Id from entity")
          end

          example(%{
            data: %{
              id: 2,
              name: "Name User",
              login: "user_login",
              email: "user@email.com",
              type: "admin",
              entity_id: 1
            }
          })
        end,
      Users:
        swagger_schema do
          title("Users")
          description("A collection of Users")
          type(:array)
          items(Schema.ref(:User))

          example(%{
            data: [
              %{
                id: 2,
                name: "Name User",
                login: "user_login",
                email: "user@email.com",
                type: "admin",
                entity_id: 1
              }
            ]
          })
        end
    }
  end

  # coveralls-ignore-stop
end
