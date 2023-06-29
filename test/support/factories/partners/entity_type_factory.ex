defmodule Arvore.Partners.EntityTypeFactory do
  @moduledoc false

  alias Arvore.Partners.EntityType

  defmacro __using__(_opts) do
    quote do
      def entity_type_factory do
        %EntityType{
          id: sequence("entity_type"),
          name: "Tipo da entidade"
        }
      end
    end
  end
end
