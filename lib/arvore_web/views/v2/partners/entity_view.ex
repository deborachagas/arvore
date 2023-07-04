defmodule ArvoreWeb.V2.Partners.EntityView do
  use ArvoreWeb, :view

  def render("index.json", %{entities: entities}) do
    %{data: render_many(entities, __MODULE__, "entity.json")}
  end

  def render("show.json", %{entity: entity}) do
    %{data: render_one(entity, __MODULE__, "entity.json")}
  end

  def render("entity.json", %{entity: entity}) do
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
