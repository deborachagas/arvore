defmodule Arvore.Repo.Migrations.SeedEntity do
  use Ecto.Migration

  alias Arvore.{Partners.Entity, Repo}

  def up do
    if Mix.env() != :test do
      %Entity{id: 1, name: "Networ01", entity_type: "network"} |> Repo.insert!()
      %Entity{id: 2, name: "Networ02", entity_type: "network"} |> Repo.insert!()

      %Entity{id: 3, name: "School01", entity_type: "school", inep: "123", parent_id: 1}
      |> Repo.insert!()

      %Entity{id: 4, name: "School02", entity_type: "school", inep: "345", parent_id: 1}
      |> Repo.insert!()

      %Entity{id: 5, name: "School03", entity_type: "school", inep: "567", parent_id: 2}
      |> Repo.insert!()

      %Entity{id: 6, name: "School04", entity_type: "school", inep: "789", parent_id: 2}
      |> Repo.insert!()

      %Entity{id: 7, name: "Class01", entity_type: "class", parent_id: 3} |> Repo.insert!()
      %Entity{id: 8, name: "Class02", entity_type: "class", parent_id: 3} |> Repo.insert!()
      %Entity{id: 9, name: "Class03", entity_type: "class", parent_id: 3} |> Repo.insert!()

      %Entity{id: 10, name: "Class04", entity_type: "class", parent_id: 4} |> Repo.insert!()
      %Entity{id: 11, name: "Class05", entity_type: "class", parent_id: 4} |> Repo.insert!()
      %Entity{id: 12, name: "Class06", entity_type: "class", parent_id: 4} |> Repo.insert!()

      %Entity{id: 13, name: "Class07", entity_type: "class", parent_id: 5} |> Repo.insert!()
      %Entity{id: 14, name: "Class08", entity_type: "class", parent_id: 5} |> Repo.insert!()
      %Entity{id: 15, name: "Class09", entity_type: "class", parent_id: 5} |> Repo.insert!()

      %Entity{id: 16, name: "Class10", entity_type: "class", parent_id: 6} |> Repo.insert!()
      %Entity{id: 17, name: "Class11", entity_type: "class", parent_id: 6} |> Repo.insert!()
      %Entity{id: 18, name: "Class12", entity_type: "class", parent_id: 6} |> Repo.insert!()
    end
  end

  def down do
    if Mix.env() != :test do
      Repo.delete_all(Entity)
    end
  end
end
