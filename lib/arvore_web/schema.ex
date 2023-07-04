defmodule ArvoreWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types(ArvoreWeb.Schema.EntityTypes)

  alias ArvoreWeb.Resolvers.Partner

  query do
    @desc "Get all entities"
    field :all_entities, list_of(:entity) do
      resolve(&Partner.all_entities/3)
    end

    @desc "Get a entity"
    field :find_entity, :entity do
      arg(:id, non_null(:id))
      resolve(&Partner.find_entity/3)
    end
  end

  mutation do
    @desc "Create a new entity"
    field :create_entity, :entity do
      arg(:name, non_null(:string))
      arg(:entity_type, non_null(:string))
      arg(:inep, :string)
      arg(:parent_id, :integer)

      resolve(&Partner.create_entity/3)
    end

    @desc "Update a entity"
    field :update_entity, :entity do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:entity_type, :string)
      arg(:inep, :string)
      arg(:parent_id, :integer)

      resolve(&Partner.update_entity/3)
    end

    @desc "Delete a entity"
    field :delete_entity, :entity do
      arg(:id, non_null(:id))

      resolve(&Partner.delete_entity/3)
    end
  end
end
