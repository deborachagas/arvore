defmodule Arvore.Partners.Entity do
  @moduledoc """
  Schema Entity.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Arvore.Accounts.User
  alias Arvore.Partners.EntityType

  @type t :: %__MODULE__{
          inep: String.t(),
          name: String.t(),
          entity_type: String.t(),
          parent: __MODULE__.t(),
          parent_id: integer()
        }

  @entity_hierarchy [
    {"class", ["school"]},
    {"school", [nil, "network"]},
    {"network", [nil]}
  ]

  schema "entities" do
    field :inep, :string
    field :name, :string
    belongs_to(:entity_type_table, EntityType, type: :string, foreign_key: :entity_type)
    belongs_to(:parent, __MODULE__, foreign_key: :parent_id)
    has_many(:subtree, __MODULE__, foreign_key: :parent_id)
    has_many(:users, User)

    timestamps()
  end

  @doc false
  def changeset(entity, attrs, parent) do
    entity
    |> cast(attrs, [:name, :inep, :entity_type, :parent_id])
    |> validate_required([:name, :entity_type])
    |> unique_constraint([:name, :entity_type])
    |> foreign_key_constraint(:entity_type)
    |> foreign_key_constraint(:parent_id)
    |> validate_inep_required()
    |> validate_entity_hierarchy(parent)
  end

  def changeset_delete(entity) do
    entity
    |> change
    |> no_assoc_constraint(:subtree)
    |> no_assoc_constraint(:users)
  end

  # inep is required only to entity type school,
  # when entity type is not school inep must be null
  defp validate_inep_required(changeset) do
    changeset
    |> get_fields_for_inep_validate()
    |> validate_inep_school(changeset)
  end

  defp get_fields_for_inep_validate(changeset),
    do: {get_field(changeset, :entity_type), get_field(changeset, :inep)}

  defp validate_inep_school({"school", _inep}, changeset),
    do: validate_required(changeset, [:inep])

  defp validate_inep_school({_type, inep}, changeset) when not is_nil(inep),
    do: add_error(changeset, :inep, "inep only for entity type school")

  defp validate_inep_school(_, changeset), do: changeset

  # entity parent must follow the hierarchy defined in the list @entity_hierarchy:
  # network: has no parent
  # school: could have no parent or a parent type Network
  # class: must be a parent type School
  defp validate_entity_hierarchy(changeset, parent) do
    changeset
    |> find_entity_hierarchy_by_type()
    |> is_valid_hierarchy(get_parent_entity_type(parent), changeset)
  end

  defp find_entity_hierarchy_by_type(changeset) do
    new_entity_type = get_field(changeset, :entity_type)

    Enum.find(@entity_hierarchy, fn {entity_type, _} ->
      new_entity_type == entity_type
    end)
  end

  defp get_parent_entity_type(%{entity_type: type}), do: type
  defp get_parent_entity_type(_), do: nil

  defp is_valid_hierarchy(nil, _parent, changeset),
    do: add_error(changeset, :entity_type, "invalid entity type")

  defp is_valid_hierarchy(
         {entity_type, hierarchy_parent_entity_type},
         parent_entity_type,
         changeset
       ) do
    if Enum.member?(hierarchy_parent_entity_type, parent_entity_type) do
      changeset
    else
      add_error(
        changeset,
        :parent_id,
        "entity type #{entity_type} must #{build_herarchy_message(hierarchy_parent_entity_type)}"
      )
    end
  end

  defp build_herarchy_message(hierarchy_parent_entity_type) do
    Enum.map_join(hierarchy_parent_entity_type, " or ", fn type ->
      if is_nil(type) do
        "has no parent"
      else
        "has parent type #{type}"
      end
    end)
  end
end
