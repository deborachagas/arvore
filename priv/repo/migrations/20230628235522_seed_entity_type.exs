defmodule Arvore.Repo.Migrations.SeedEntityType do
  use Ecto.Migration

  alias Arvore.{Partners.EntityType, Repo}

  @types [{"network", "Network"}, {"school", "School"}, {"class", "Class"}]

  def up do
    for {id, name} <- @types do
      Repo.insert!(%EntityType{id: id, name: name})
    end
  end

  def down do
    Repo.delete_all(EntityType)
  end
end
