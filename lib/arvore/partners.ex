defmodule Arvore.Partners do
  @moduledoc """
  The Partners context.
  """

  import Ecto.Query, warn: false
  alias Arvore.Partners.Entity
  alias Arvore.Repo
  alias Ecto.Changeset

  @doc """
  List all entities.

  Returns empty list if has no entity

  ## Examples

      iex> list_entities()
      [%Entity{}, ..]

      iex> list_entities()
      []

  """
  @spec list_entities() :: nil | [Entity.t()]
  def list_entities, do: Entity |> Repo.all() |> Repo.preload([:parent, :subtree])

  @doc """
  Gets a single entity.

  Returns nil if the Entity does not exist.

  ## Examples

      iex> get_entity(123)
      %Entity{}

      iex> get_entity(456)
      nil

      iex> get_entity(nil)
      nil

  """
  @spec get_entity(integer()) :: nil | Entity.t()
  def get_entity(nil), do: nil
  def get_entity(""), do: nil

  def get_entity(id) when not is_integer(id) do
    case Integer.parse(id) do
      {id, ""} -> get_entity(id)
      _ -> nil
    end
  end

  def get_entity(id), do: Entity |> Repo.get(id) |> Repo.preload([:parent, :subtree])

  @doc """
  Creates a entity.

  ## Examples

      iex> create_entity(%{field: value})
      {:ok, %Entity{}}

      iex> create_entity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @type create_entity_params :: %{
          required(:name) => String.t(),
          required(:entity_type) => String.t(),
          optional(:ineb) => String.t(),
          optional(:parent_id) => integer()
        }
  @spec create_entity(create_entity_params) :: {:ok, Entity.t()} | {:error, Changeset.t()}
  def create_entity(attrs \\ %{}) do
    parent = get_entity(attrs["parent_id"])

    %Entity{}
    |> Entity.changeset(attrs, parent)
    |> Repo.insert()
  end

  @doc """
  Updates a entity.

  ## Examples

      iex> update_entity(entity, %{field: new_value})
      {:ok, %Entity{}}

      iex> update_entity(entity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @type update_entity_params :: %{
          optional(:name) => String.t(),
          optional(:entity_type) => String.t(),
          optional(:ineb) => String.t(),
          optional(:parent_id) => integer()
        }
  @spec update_entity(Entity.t(), update_entity_params) ::
          {:ok, Entity.t()} | {:error, Changeset.t()}
  def update_entity(%Entity{} = entity, attrs) do
    parent = get_entity(attrs["parent_id"])

    entity
    |> Entity.changeset(attrs, parent)
    |> Repo.update()
  end

  @doc """
  Deletes a entity.

  ## Examples

      iex> delete_entity(entity)
      {:ok, %Entity{}}

      iex> delete_entity(entity)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_entity(Entity.t()) :: {:ok, Entity.t()} | {:error, Changeset.t()}
  def delete_entity(%Entity{} = entity) do
    entity
    |> Entity.changeset_delete()
    |> Repo.delete()
  end
end
