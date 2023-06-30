defmodule Arvore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :login, :string, null: false
      add :type, :string, null: false
      add :password, :string, null: false
      add :entity_id, references(:entities)

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:login])
  end
end
