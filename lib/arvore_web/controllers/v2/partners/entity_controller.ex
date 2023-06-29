defmodule ArvoreWeb.V2.Partners.EntityController do
  use ArvoreWeb, :controller

  alias Arvore.Partners
  alias Arvore.Partners.Entity

  action_fallback ArvoreWeb.FallbackController

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
    entity = Partners.get_entity(entity_params["id"])

    # case Partners.update_entity(entity, entity_params) do
    #   {:ok, entity} ->
    #     conn
    #     |> put_flash(:info, "Entity updated successfully.")
    #     |> redirect(to: Routes.entity_path(conn, :show, entity))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.json", entity: entity, changeset: changeset)
    # end
  end
end
