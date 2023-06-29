defmodule Arvore.Partners.Entity do
  @moduledoc """
  Schema Entity.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Arvore.Partners.EntityType

  @type t :: %__MODULE__{
          inep: String.t(),
          name: String.t(),
          entity_type: String.t(),
          entity: __MODULE__.t(),
          parent_id: integer()
        }

  schema "entities" do
    field :inep, :string
    field :name, :string
    belongs_to(:entity_type_table, EntityType, type: :string, foreign_key: :entity_type)
    belongs_to(:entity, __MODULE__, foreign_key: :parent_id)
    has_many(:subtree, __MODULE__, foreign_key: :parent_id)

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

  defp validate_inep_required(changeset) do
    changeset
    |> get_fields_for_inep_validate()
    |> validate_inep_school(changeset)
  end

  defp get_fields_for_inep_validate(changeset) do
    {get_field(changeset, :entity_type), get_field(changeset, :inep)}
  end

  defp validate_inep_school({"school", _inep}, changeset),
    do: validate_required(changeset, [:inep])

  defp validate_inep_school({_type, inep}, changeset) when not is_nil(inep),
    do: add_error(changeset, :inep, "inep only for entity type school")

  defp validate_inep_school(_, changeset), do: changeset

  @entity_hierarchy [
    {"class", ["school"]},
    {"school", [nil, "network"]},
    {"network", [nil]}
  ]

  defp validate_entity_hierarchy(changeset, parent) do
    changeset
    |> find_entity_hierarchy()
    |> is_valid_hierarchy(parent, changeset)
  end

  defp find_entity_hierarchy(changeset) do
    new_entity_type = get_field(changeset, :entity_type)

    Enum.find(@entity_hierarchy, fn {entity_type, _} ->
      new_entity_type == entity_type
    end)
  end

  defp is_valid_hierarchy(nil, _parent, changeset),
    do: add_error(changeset, :entity_type, "invalid entity type")

  defp is_valid_hierarchy(entity_hierarchy, %{entity_type: parent_entity_type}, changeset),
    do: is_valid_hierarchy(entity_hierarchy, parent_entity_type, changeset)

  defp is_valid_hierarchy({_, hierarchy_parent_entity_type}, parent_entity_type, changeset) do
    if not Enum.member?(hierarchy_parent_entity_type, parent_entity_type) do
      add_error(changeset, :parent_id, "invalid entity parent type")
    else
      changeset
    end
  end
end
