defmodule Arvore.Partners do
  @moduledoc """
  The Partners context.
  """

  import Ecto.Query, warn: false
  alias Arvore.Repo

  alias Arvore.Partners.Entity

  @doc """
  Gets a single entity.

  Raises `Ecto.NoResultsError` if the Entity does not exist.

  ## Examples

      iex> get_entity(123)
      %Entity{}

      iex> get_entity(456)
      ** (Ecto.NoResultsError)

  """
  def get_entity(nil), do: nil
  def get_entity(""), do: nil
  def get_entity(id), do: Repo.get(Entity, id)

  @doc """
  Creates a entity.

  ## Examples

      iex> create_entity(%{field: value})
      {:ok, %Entity{}}

      iex> create_entity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  def update_entity(%Entity{} = entity, attrs) do
    parent = get_entity(attrs["parent_id"])

    entity
    |> Entity.changeset(attrs, parent)
    |> Repo.update()
  end
end
