defmodule Arvore.Accounts.UserFactory do
  @moduledoc false

  alias Arvore.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          name: sequence("Nome do usuário"),
          email: sequence("email"),
          login: sequence("login"),
          type: "admin",
          password: sequence("password"),
          entity_id: nil
        }
      end
    end
  end
end
