defmodule ArvoreWeb.V2.Partners.EntityView do
  use ArvoreWeb, :view

  def render("show.json", %{entity: entity}) do
    %{data: render_one(entity, __MODULE__, "entity.json")}
  end

  def render("entity.json", %{entity: entity}) do
    entity = Arvore.Repo.preload(entity, [:subtree])

    %{
      id: entity.id,
      name: entity.name,
      inep: entity.inep,
      entity_type: entity.entity_type,
      parent_id: entity.parent_id,
      subtree_ids: Enum.map(entity.subtree, & &1.id)
    }
  end
end
