defmodule Arvore.Partners.EntityType do
  @moduledoc """
  Schema Entinty Type
  """
  use Ecto.Schema
  @primary_key {:id, :string, []}

  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  schema "entity_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(entity_type, attrs) do
    entity_type
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
    |> unique_constraint(:name)
  end
end
