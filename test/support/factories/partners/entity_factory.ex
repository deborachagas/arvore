defmodule Arvore.Partners.EntityFactory do
  @moduledoc false

  alias Arvore.Partners.Entity

  defmacro __using__(_opts) do
    quote do
      def entity_factory do
        %Entity{
          name: sequence("Nome da entidade"),
          entity_type: "class",
          inep: sequence("inep"),
          parent_id: nil
        }
      end
    end
  end
end
