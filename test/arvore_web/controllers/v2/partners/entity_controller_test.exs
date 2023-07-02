defmodule ArvoreWeb.Partners.EntityControllerTest do
  use ArvoreWeb.ConnCase

  alias Arvore.Partners

  import Mock

  setup_with_mocks([{ArvoreWeb.JwtAuthPlug, [], [call: fn conn, _ -> conn end]}]) do
    :ok
  end

  describe "list entities" do
    test "return list of entities", %{conn: conn} do
      entity = insert(:entity)

      response =
        conn
        |> get(Routes.entity_path(conn, :index))
        |> json_response(:ok)

      [response_entity] = response["data"]

      assert response_entity == %{
               "entity_type" => entity.entity_type,
               "id" => response_entity["id"],
               "inep" => entity.inep,
               "name" => entity.name,
               "parent_id" => entity.parent_id,
               "subtree_ids" => []
             }
    end

    test "return empty list if has no entity", %{conn: conn} do
      response =
        conn
        |> get(Routes.entity_path(conn, :index))
        |> json_response(:ok)

      assert [] == response["data"]
    end
  end

  describe "get entity" do
    test "return json entity by id", %{conn: conn} do
      entity = insert(:entity)

      response =
        conn
        |> get(Routes.entity_path(conn, :show, entity.id))
        |> json_response(:ok)

      assert response["data"] == %{
               "entity_type" => entity.entity_type,
               "id" => response["data"]["id"],
               "inep" => entity.inep,
               "name" => entity.name,
               "parent_id" => entity.parent_id,
               "subtree_ids" => []
             }
    end

    test "return json entity by id when has subtree", %{conn: conn} do
      entity_school = insert(:entity, entity_type: "school")

      [%{id: entity_class_id_1}, %{id: entity_class_id_2}] =
        insert_pair(:entity, entity_type: "class", inep: nil, parent_id: entity_school.id)

      response =
        conn
        |> get(Routes.entity_path(conn, :show, entity_school.id))
        |> json_response(:ok)

      assert response["data"] == %{
               "entity_type" => entity_school.entity_type,
               "id" => response["data"]["id"],
               "inep" => entity_school.inep,
               "name" => entity_school.name,
               "parent_id" => entity_school.parent_id,
               "subtree_ids" => [entity_class_id_1, entity_class_id_2]
             }
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

      assert response["data"] == %{
               "entity_type" => entity.entity_type,
               "id" => response["data"]["id"],
               "inep" => entity.inep,
               "name" => entity.name,
               "parent_id" => entity.parent_id,
               "subtree_ids" => []
             }
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

    test "return json entity when data is valid", %{conn: conn, entity: entity} do
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

      assert response["data"] == %{
               "entity_type" => update_attrs["entity_type"],
               "id" => response["data"]["id"],
               "inep" => update_attrs["inep"],
               "name" => update_attrs["name"],
               "parent_id" => nil,
               "subtree_ids" => []
             }
    end

    test "return errors when entity not found", %{conn: conn} do
      response =
        conn
        |> put(Routes.entity_path(conn, :update, 2, %{}))
        |> json_response(:not_found)

      assert response == %{"error" => "Not found"}
    end

    test "return errors when data is invalid", %{conn: conn, entity: entity} do
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

  describe "delete entity" do
    setup do
      {:ok, entity: insert(:entity, entity: insert(:entity, entity_type: "network"))}
    end

    test "return json entity when deleted", %{conn: conn, entity: entity} do
      response =
        conn
        |> delete(Routes.entity_path(conn, :delete, entity.id))
        |> json_response(:ok)

      assert response["data"] == %{
               "entity_type" => entity.entity_type,
               "id" => response["data"]["id"],
               "inep" => entity.inep,
               "name" => entity.name,
               "parent_id" => entity.parent_id,
               "subtree_ids" => []
             }
    end

    test "return errors when entity has associated data", %{conn: conn, entity: entity} do
      insert(:entity, entity_type: "school", inep: "123", parent_id: entity.id)

      response =
        conn
        |> delete(Routes.entity_path(conn, :delete, entity.id))
        |> json_response(:unprocessable_entity)

      assert response == %{"errors" => %{"subtree" => ["are still associated with this entry"]}}
    end

    test "return not found error message when id not exists", %{conn: conn} do
      response =
        conn
        |> delete(Routes.entity_path(conn, :delete, 1))
        |> json_response(:not_found)

      assert response["error"] == "Not found"
    end
  end
end
