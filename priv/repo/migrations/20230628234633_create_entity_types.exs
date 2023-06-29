defmodule Arvore.Repo.Migrations.CreateEntityTypes do
  use Ecto.Migration

  def change do
    create table(:entity_types, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:entity_types, [:name])
  end
end
