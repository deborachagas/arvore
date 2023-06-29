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

  # describe "edit entity" do
  #   setup [:create_entity]

  #   test "renders form for editing chosen entity", %{conn: conn, entity: entity} do
  #     conn = get(conn, Routes.entity_path(conn, :edit, entity))
  #     assert html_response(conn, 200) =~ "Edit Entity"
  #   end
  # end

  # describe "update entity" do
  #   setup [:create_entity]

  #   test "redirects when data is valid", %{conn: conn, entity: entity} do
  #     conn = put(conn, Routes.entity_path(conn, :update, entity), entity: @update_attrs)
  #     assert redirected_to(conn) == Routes.entity_path(conn, :show, entity)

  #     conn = get(conn, Routes.entity_path(conn, :show, entity))
  #     assert html_response(conn, 200)
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, entity: entity} do
  #     conn = put(conn, Routes.entity_path(conn, :update, entity), entity: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Entity"
  #   end
  # end

  # describe "delete entity" do
  #   setup [:create_entity]

  #   test "deletes chosen entity", %{conn: conn, entity: entity} do
  #     conn = delete(conn, Routes.entity_path(conn, :delete, entity))
  #     assert redirected_to(conn) == Routes.entity_path(conn, :index)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.entity_path(conn, :show, entity))
  #     end
  #   end
  # end

  # defp create_entity(_) do
  #   entity = fixture(:entity)
  #   %{entity: entity}
  # end
end
