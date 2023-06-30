defmodule Arvore.PartnersTest do
  use Arvore.DataCase

  alias Arvore.Partners
  alias Arvore.Partners.Entity

  describe "list_entities/0" do
    test "returns a list of entities" do
      entity = insert(:entity)
      assert Partners.list_entities() == [entity]
    end

    test "returns a empty list if has no entity" do
      assert Partners.list_entities() == []
    end
  end

  describe "get_entity/0" do
    test "returns the entity with given id" do
      entity = insert(:entity)
      assert Partners.get_entity(entity.id) == entity
    end

    test "returns nil with given id is nil" do
      assert Partners.get_entity(nil) == nil
    end

    test "returns nil with given id not exists" do
      assert Partners.get_entity(2) == nil
    end
  end

  describe "create_entity/1" do
    test "with valid data creates a entity network" do
      attrs_entity_network = %{"name" => "Network", "entity_type" => "network"}
      assert {:ok, %Entity{} = entity} = Partners.create_entity(attrs_entity_network)
      assert entity.name == "Network"
      assert entity.entity_type == "network"
    end

    test "with valid data creates a entity school with no parent" do
      attrs_entity_school = %{"name" => "School", "entity_type" => "school", "inep" => "inep"}
      assert {:ok, %Entity{} = entity} = Partners.create_entity(attrs_entity_school)
      assert entity.name == "School"
      assert entity.entity_type == "school"
    end

    test "with valid data creates a entity school with parent" do
      entity = insert(:entity, entity_type: "network")

      attrs_entity_school = %{
        "name" => "School",
        "entity_type" => "school",
        "inep" => "inep",
        "parent_id" => entity.id
      }

      assert {:ok, %Entity{} = entity} = Partners.create_entity(attrs_entity_school)
      assert entity.name == "School"
      assert entity.entity_type == "school"
    end

    test "with valid data creates a entity class" do
      entity = insert(:entity, entity_type: "school")

      attrs_entity_school = %{
        "name" => "Class",
        "entity_type" => "class",
        "parent_id" => entity.id
      }

      assert {:ok, %Entity{} = entity} = Partners.create_entity(attrs_entity_school)
      assert entity.name == "Class"
      assert entity.entity_type == "class"
    end

    test "returns error changeset when required fields are nil" do
      invalid_attrs = %{}
      assert {:error, %Ecto.Changeset{} = changeset} = Partners.create_entity(invalid_attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).entity_type
    end

    test "returns error changeset when name to entity_type alredy exists" do
      entity = insert(:entity, name: "Entity1", entity_type: "network")

      invalid_attrs = %{"name" => entity.name, "entity_type" => entity.entity_type}
      assert {:error, %Ecto.Changeset{} = changeset} = Partners.create_entity(invalid_attrs)
      assert "has already been taken" in errors_on(changeset).name

      valid_attrs = %{"name" => entity.name, "entity_type" => "school", "inep" => "inep"}
      assert {:ok, %Entity{}} = Partners.create_entity(valid_attrs)
    end

    test "returns error changeset when entity type is invalid" do
      invalid_attrs = %{"name" => "name", "entity_type" => "invalid"}
      assert {:error, %Ecto.Changeset{} = changeset} = Partners.create_entity(invalid_attrs)
      assert "invalid entity type" in errors_on(changeset).entity_type
    end

    test "returns error changeset when inep is null to entity type school" do
      attrs_entity_school = %{"name" => "School", "entity_type" => "school", "inep" => nil}

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_school)

      assert "can't be blank" in errors_on(changeset).inep
    end

    test "returns error changeset when inep is not null when entity type is not school" do
      attrs_entity_network = %{
        "name" => "Network",
        "entity_type" => "network",
        "inep" => "inep",
        "parent_id" => nil
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_network)

      assert "inep only for entity type school" in errors_on(changeset).inep

      entity = insert(:entity, entity_type: "school")

      attrs_entity_network = %{
        "name" => "Class",
        "entity_type" => "class",
        "inep" => "inep",
        "parent_id" => entity.parent_id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_network)

      assert "inep only for entity type school" in errors_on(changeset).inep
    end

    test "returns error changeset when parent id is not null to entity type network" do
      entity = insert(:entity, entity_type: "network")

      attrs_entity_network = %{
        "name" => "Network",
        "entity_type" => "network",
        "parent_id" => entity.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_network)

      assert "entity type network must has no parent" in errors_on(changeset).parent_id
    end

    test "returns error changeset when parent id is not type network to entity type school" do
      entity = insert(:entity, entity_type: "school")

      attrs_entity_school = %{
        "name" => "School",
        "entity_type" => "school",
        "inep" => "inep",
        "parent_id" => entity.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_school)

      assert "entity type school must has no parent or has parent type network" in errors_on(
               changeset
             ).parent_id
    end

    test "returns error changeset when parent entity type is not school to entity type class" do
      entity = insert(:entity, entity_type: "network")

      attrs_entity_school = %{
        "name" => "Class",
        "entity_type" => "class",
        "parent_id" => entity.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.create_entity(attrs_entity_school)

      assert "entity type class must has parent type school" in errors_on(changeset).parent_id
    end
  end

  describe "update_entity/2" do
    setup do
      {:ok, entity: insert(:entity)}
    end

    test "with valid data updates the entity", %{entity: entity} do
      update_attrs = %{
        "name" => "Teste update",
        "entity_type" => "school",
        "inep" => "789123",
        "parent_id" => nil
      }

      assert {:ok, %Entity{} = updated_entity} = Partners.update_entity(entity, update_attrs)

      assert updated_entity.name == update_attrs["name"]
      assert updated_entity.entity_type == update_attrs["entity_type"]
      assert updated_entity.inep == update_attrs["inep"]
      assert updated_entity.parent_id == update_attrs["parent_id"]
    end

    test "with invalid data returns error changeset", %{entity: entity} do
      update_attrs = %{
        "name" => nil,
        "entity_type" => "class",
        "inep" => "789123",
        "parent_id" => nil
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Partners.update_entity(entity, update_attrs)

      assert entity == Partners.get_entity(entity.id)

      assert "entity type class must has parent type school" in errors_on(changeset).parent_id
      assert "inep only for entity type school" in errors_on(changeset).inep
      assert "can't be blank" in errors_on(changeset).name
    end
  end

  describe "delete_entity/2" do
    setup do
      {:ok, entity: insert(:entity, entity_type: "network")}
    end

    test "success deletes the entity", %{entity: entity} do
      assert {:ok, %Entity{} = deleted_entity} = Partners.delete_entity(entity)
      assert deleted_entity.id == entity.id
      assert Partners.get_entity(entity.id) == nil
    end

    test "when has associate entity returns error changeset", %{entity: entity} do
      insert(:entity, entity_type: "school", inep: "123", parent_id: entity.id)
      assert {:error, %Ecto.Changeset{} = changeset} = Partners.delete_entity(entity)
      assert "are still associated with this entry" in errors_on(changeset).subtree
    end

    test "when has associate user returns error changeset", %{entity: entity} do
      insert(:user, entity_id: entity.id)
      assert {:error, %Ecto.Changeset{} = changeset} = Partners.delete_entity(entity)
      assert "are still associated with this entry" in errors_on(changeset).users
    end
  end
end
