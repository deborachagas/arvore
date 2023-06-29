defmodule Arvore.Repo.Migrations.CreateEntityTypes do
  use Ecto.Migration

  def change do
    create table(:entity_types) do
      add :name, :string

      timestamps()
    end

    create unique_index(:entity_types, [:name])
  end
end
