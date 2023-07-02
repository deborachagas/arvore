defmodule Arvore.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Arvore.Repo

  alias Arvore.Accounts.{ArvoreToken, User}

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

  @doc """
  Login user with login and password.

  ## Examples

      iex> login("user_login", "user_password")
      {:ok, "eyJhbGciOiJIUzI1Ni...GoAH7BJFaypBzHBWWU"}

      iex> login(user)
      {:error, :user_not_found}
  """
  @spec login(String.t(), String.t()) ::
          {:ok, String.t()}
          | {:error, :user_not_found}
          | {:error, :invalid_password}
  def login(login, password) do
    with %User{} = user <- Repo.get_by(User, login: login),
         true <- Bcrypt.verify_pass(password, user.password),
         {:ok, jwt, _claims} <- ArvoreToken.encode_and_sign(user, nil) do
      {:ok, jwt}
    else
      nil -> {:error, :user_not_found}
      false -> {:error, :invalid_password}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Validates if jwt is valid

  ## Examples

      iex> validate_token("eyJhbGciOiJIUzI1Ni...GoAH7BJFaypBzHBWWU")
      {:ok, "eyJhbGciOiJIUzI1Ni...GoAH7BJFaypBzHBWWU"}

      iex> validate_token(nil)
      {:error, "Invalid token"}
  """
  @type claim :: %{
          exp: integer(),
          iat: integer(),
          iss: String.t(),
          jti: String.t(),
          nbf: integer(),
          sub: integer(),
          user_login: String.t(),
          user_type: String.t()
        }
  @spec validate_token(String.t()) :: {:ok, claim()} | {:error, String.t()}
  def validate_token(jwt) do
    case ArvoreToken.verify(jwt, nil) do
      {:ok, claim} -> {:ok, claim}
      {:error, [message: msg, claim: _claim, claim_val: _val]} -> {:error, msg}
      _ -> {:error, "Invalid token"}
    end
  end
end
