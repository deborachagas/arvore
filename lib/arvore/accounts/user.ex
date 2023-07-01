defmodule Arvore.Accounts.User do
  @moduledoc """
  Schema User.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Arvore.Partners.Entity

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          login: String.t(),
          type: String.t(),
          password: String.t(),
          entity: Entity.t(),
          entity_id: integer()
        }

  schema "users" do
    field :name, :string
    field :email, :string
    field :login, :string
    field :type, :string
    field :password, :string
    belongs_to(:entity, Entity)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :login, :type, :password, :entity_id])
    |> validate_required([:name, :email, :login, :type, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> foreign_key_constraint(:entity_id)
    |> unique_constraint([:email])
    |> unique_constraint([:login])
    |> hash_password()
  end

  defp hash_password(changeset) do
    password =
      changeset
      |> get_field(:password)
      |> Bcrypt.hash_pwd_salt()

    put_change(changeset, :password, password)
  end
end
