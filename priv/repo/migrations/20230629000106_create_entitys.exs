defmodule Arvore.Repo.Migrations.CreateEntitys do
  use Ecto.Migration

  def change do
    create table(:entitys) do
      add :name, :string, null: false
      add :inep, :string, null: false
      add :entity_type, references(:entity_types)
      add :parend_id, references(:entitys)

      timestamps()
    end

    create index(:entitys, [:entity_type])
    create index(:entitys, [:parend_id])
  end
end
