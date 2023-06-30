defmodule ArvoreWeb.Partners.EntityControllerTest do
  use ArvoreWeb.ConnCase

  alias Arvore.Partners

  describe "get entity" do
    test "return json entity by id", %{conn: conn} do
      entity = insert(:entity)

      response =
        conn
        |> get(Routes.entity_path(conn, :show, entity.id))
        |> json_response(:ok)

      assert response["data"]["name"] == entity.name
      assert response["data"]["entity_type"] == entity.entity_type
    end

    test "return not found error message when id not exists", %{conn: conn} do
      response =
        conn
        |> get(Routes.entity_path(conn, :show, 1))
        |> json_response(:not_found)

      assert response["error"] == "Not found"
    end
  end

  describe "create entity" do
    test "return json entity when create", %{conn: conn} do
      attrs_entity_network = %{"name" => "Network", "entity_type" => "network"}

      response =
        conn
        |> post(Routes.entity_path(conn, :create, attrs_entity_network))
        |> json_response(:created)

      entity = Partners.get_entity(response["data"]["id"])
      assert response["data"]["name"] == entity.name
      assert response["data"]["entity_type"] == entity.entity_type
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{"entity_type" => "school"}

      response =
        conn
        |> post(Routes.entity_path(conn, :create, invalid_attrs))
        |> json_response(:unprocessable_entity)

      assert response == %{
               "errors" => %{
                 "inep" => ["can't be blank"],
                 "name" => ["can't be blank"]
               }
             }
    end
  end

  describe "update entity" do
    setup do
      {:ok, entity: insert(:entity)}
    end

    test "redirects when data is valid", %{conn: conn, entity: entity} do
      update_attrs = %{
        "name" => "Teste update",
        "entity_type" => "school",
        "inep" => "789123",
        "parent_id" => nil
      }

      response =
        conn
        |> put(Routes.entity_path(conn, :update, entity.id, update_attrs))
        |> json_response(:ok)

      assert response["data"]["name"] == "Teste update"
      assert response["data"]["entity_type"] == "school"
      assert response["data"]["inep"] == "789123"
      assert response["data"]["parent_id"] == nil
    end

    test "renders errors when entity not found", %{conn: conn} do
      response =
        conn
        |> put(Routes.entity_path(conn, :update, 2, %{}))
        |> json_response(:not_found)

      assert response == %{"error" => "Not found"}
    end

    test "renders errors when data is invalid", %{conn: conn, entity: entity} do
      invalid_attrs = %{
        "name" => nil,
        "entity_type" => "class",
        "parent_id" => nil,
        "inep" => "1123"
      }

      response =
        conn
        |> put(Routes.entity_path(conn, :update, entity.id, invalid_attrs))
        |> json_response(:unprocessable_entity)

      assert response == %{
               "errors" => %{
                 "inep" => ["inep only for entity type school"],
                 "parent_id" => ["entity type class must has parent type school"],
                 "name" => ["can't be blank"]
               }
             }
    end
  end
end
