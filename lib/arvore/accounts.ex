defmodule Arvore.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Arvore.Repo

  alias Arvore.Accounts.User

  @doc """
  Returns the list of users.

  Returns empty list if has no user

  ## Examples

      iex> list_users()
      [%User{}, ...]

      iex> list_users()
      []

  """
  @spec list_users() :: nil | [User.t()]
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  @spec get_user(integer()) :: nil | User.t()
  def get_user(nil), do: nil
  def get_user(""), do: nil

  def get_user(id) when not is_integer(id) do
    case Integer.parse(id) do
      {id, ""} -> get_user(id)
      _ -> nil
    end
  end

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @type create_user_params :: %{
          required(:name) => String.t(),
          required(:email) => String.t(),
          required(:login) => String.t(),
          required(:password) => String.t(),
          required(:type) => String.t(),
          optional(:entity_id) => integer()
        }
  @spec create_user(create_user_params) :: {:ok, User.t()} | {:error, Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @type update_user_params :: %{
          required(:name) => String.t(),
          required(:email) => String.t(),
          required(:login) => String.t(),
          required(:password) => String.t(),
          required(:type) => String.t(),
          optional(:entity_id) => integer()
        }
  @spec update_user(User.t(), update_user_params) ::
          {:ok, User.t()} | {:error, Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
