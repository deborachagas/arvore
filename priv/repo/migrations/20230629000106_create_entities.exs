defmodule Arvore.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :name, :string, null: false
      add :inep, :string
      add :entity_type, references(:entity_types, type: :string), null: false
      add :parent_id, references(:entities)

      timestamps()
    end

    create unique_index(:entities, [:name, :entity_type])
  end
end
