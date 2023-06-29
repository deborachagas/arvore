defmodule Arvore.Arvore.EntityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entitys" do
    field :inep, :string
    field :name, :string
    field :entity_type, :id
    field :parend_id, :id

    timestamps()
  end

  @doc false
  def changeset(entity_type, attrs) do
    entity_type
    |> cast(attrs, [:name, :inep])
    |> validate_required([:name, :inep])
  end
end
