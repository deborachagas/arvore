defmodule ArvoreWeb.Resolvers.Partner do
  @moduledoc false

  alias Arvore.Partners
  alias Arvore.Partners.Entity

  def all_entities(_root, _args, _info) do
    {:ok, Partners.list_entities()}
  end

  def find_entity(_parent, %{id: id}, _resolution) do
    case Partners.get_entity(id) do
      nil ->
        {:error, "Entity ID #{id} not found"}

      entity ->
        {:ok, entity}
    end
  end

  def create_entity(_root, args, _info) do
    case Partners.create_entity(args) do
      {:ok, entity} ->
        {:ok, entity}

      _ ->
        {:error, "could not create entity"}
    end
  end

  def update_entity(_root, args, _info) do
    with %Entity{} = entity <- Partners.get_entity(args.id),
         {:ok, entity} <- Partners.update_entity(entity, args) do
      {:ok, entity}
    else
      nil -> {:error, "Entity ID #{args.id} not found"}
      _ -> {:error, "could not update entity"}
    end
  end

  def delete_entity(_root, %{id: id}, _info) do
    with %Entity{} = entity <- Partners.get_entity(id),
         {:ok, entity} <- Partners.delete_entity(entity) do
      {:ok, entity}
    else
      nil -> {:error, "Entity ID #{id} not found"}
      _ -> {:error, "could not delete entity"}
    end
  end
end
