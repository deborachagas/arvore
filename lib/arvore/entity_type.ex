defmodule Arvore.EntityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entity_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(entity_type, attrs) do
    entity_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
