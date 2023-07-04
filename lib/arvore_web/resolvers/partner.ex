defmodule ArvoreWeb.Resolvers.Partner do
  @moduledoc false

  alias Arvore.Partners

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
end
