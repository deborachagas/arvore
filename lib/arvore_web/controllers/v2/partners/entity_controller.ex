defmodule ArvoreWeb.V2.Partners.EntityController do
  use ArvoreWeb, :controller

  alias Arvore.Partners
  alias Arvore.Partners.Entity
  # alias Ecto.Changeset

  action_fallback ArvoreWeb.FallbackController

  use PhoenixSwagger

  swagger_path :index do
    get("/api/v2/partners/entities")
    description("List entities")
    tag("Entity")
    produces("application/json")
    response(200, "Ok", Schema.ref(:Entities))
  end

  swagger_path :show do
    get("/api/v2/partners/entities/{id}")
    description("Get entity by id")
    tag("Entity")

    parameters do
      id(:integer, 1, "Entity ID", required: true)
    end

    produces("application/json")
    response(200, "Ok", Schema.ref(:Entity))
    response(404, "Not found")
  end

  swagger_path :create do
    post("/api/v2/partners/entities")
    description("Create entity")
    tag("Entity")

    parameters do
      name(:string, "Entity Name", "Name of entity", required: true)

      entity_type(:string, "networ", "Type of entity, can be: network, school or class",
        required: true
      )

      inep(:string, "323", "Identifier of school, is required only for entity type school")

      parent_id(
        :integer,
        1,
        "Entity parent. Entity type network, parent_id must be null. Entity type school, parent_id must be type network. Entity type class, parent_id must be school"
      )
    end

    response(201, "Created", Schema.ref(:Entity))
    response(422, "Unproccessable entity")
  end

  swagger_path :update do
    put("/api/v2/partners/entities/{id}")
    description("Update entity")
    tag("Entity")

    parameters do
      id(:integer, 1, "Entity ID", required: true)
      name(:string, "Entity Name", "Name of entity")
      entity_type(:string, "networ", "Type of entity, can be: network, school or class")
      inep(:string, "323", "Identifier of school, is required only for entity type school")

      parent_id(
        :integer,
        1,
        "Entity parent. Entity type network, parent_id must be null. Entity type school, parent_id must be type network. Entity type class, parent_id must be school"
      )
    end

    response(200, "Success", Schema.ref(:Entity))
    response(404, "Not found")
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/v2/partners/entities/{id}")
    description("Delete entity")
    tag("Entity")

    parameters do
      id(:integer, 1, "Entity ID", required: true)
    end

    response(200, "Success", Schema.ref(:Entity))
    response(404, "Not found")
  end

  def index(conn, _) do
    entities = Partners.list_entities()
    render(conn, "index.json", entities: entities)
  end

  def show(conn, %{"id" => id}) do
    case Partners.get_entity(id) do
      %Entity{} = entity -> render(conn, "show.json", entity: entity)
      nil -> {:error, :not_found}
    end
  end

  def create(conn, entity_params) do
    with {:ok, %Entity{} = entity} <- Partners.create_entity(entity_params) do
      conn
      |> put_status(:created)
      |> render("show.json", entity: entity)
    end
  end

  def update(conn, entity_params) do
    with %Entity{} = entity <- Partners.get_entity(entity_params["id"]),
         {:ok, entity} <- Partners.update_entity(entity, entity_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", entity: entity)
    else
      nil -> {:error, :not_found}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Entity{} = entity <- Partners.get_entity(id),
         {:ok, entity} <- Partners.delete_entity(entity) do
      conn
      |> put_status(:ok)
      |> render("show.json", entity: entity)
    else
      nil -> {:error, :not_found}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def swagger_definitions do
    %{
      Entity:
        swagger_schema do
          title("Entity")
          description("A entity of the application")

          properties do
            id(:id, "Entity id", required: true)
            name(:string, "Entity name", required: true)
            entity_type(:string, "Entity type", required: true)
            inep(:string, "Inep")
            parent_id(:integer, "Entity id parent")
          end

          example(%{
            data: %{
              id: 2,
              name: "School",
              entity_type: "school",
              inep: "inep",
              parent_id: 1
            }
          })
        end,
      Entities:
        swagger_schema do
          title("Entities")
          description("A collection of Entities")
          type(:array)
          items(Schema.ref(:Entity))

          example(%{
            data: [
              %{
                id: 2,
                name: "School",
                entity_type: "school",
                inep: "inep",
                parent_id: 1
              }
            ]
          })
        end
    }
  end
end
