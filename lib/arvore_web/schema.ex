defmodule ArvoreWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types(ArvoreWeb.Schema.EntityTypes)

  alias ArvoreWeb.Resolvers.Partner

  query do
    @desc "Get all entities"
    field :all_entities, non_null(list_of(non_null(:entity))) do
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
  end
end
