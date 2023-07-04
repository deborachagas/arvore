defmodule ArvoreWeb.Schema.EntityTypes do
  use Absinthe.Schema.Notation

  @desc "A entity of the partner"
  object :entity do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :entity_type, non_null(:string)
    field :inep, :string
    field :parent_id, :integer
    field :parent, :entity
    field :subtree, list_of(:entity)
  end
end
