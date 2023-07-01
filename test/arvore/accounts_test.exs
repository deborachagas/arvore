defmodule Arvore.AccountsTest do
  use Arvore.DataCase

  alias Arvore.Accounts
  alias Arvore.Accounts.User

  @valid_attrs %{
    "name" => "name",
    "login" => "login",
    "email" => "email@teste.com",
    "password" => "password",
    "type" => "admin"
  }

  describe "list_users/0" do
    test "returns a list of users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "returns a empty list if has no user" do
      assert Accounts.list_users() == []
    end
  end

  describe "get_user/0" do
    test "returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user(user.id) == user
    end

    test "returns nil with given id is nil" do
      assert Accounts.get_user(nil) == nil
    end

    test "returns nil with given id not exists" do
      assert Accounts.get_user(2) == nil
    end
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert user.name == @valid_attrs["name"]
      assert user.login == @valid_attrs["login"]
      assert user.email == @valid_attrs["email"]
      assert user.type == @valid_attrs["type"]
    end

    test "returns error changeset when required values are nil" do
      attrs = %{}
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs)
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).login
      assert "can't be blank" in errors_on(changeset).type
      assert "can't be blank" in errors_on(changeset).password
    end

    test "returns error changeset when name to unique fields alredy exists" do
      insert(:user, email: @valid_attrs["email"], login: @valid_attrs["login"])

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_attrs)
      assert "has already been taken" in errors_on(changeset).email

      attrs = Map.put(@valid_attrs, "email", "email2@teste.com")

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs)
      assert "has already been taken" in errors_on(changeset).login
    end

    test "returns error changeset when email is invalid" do
      attrs = Map.put(@valid_attrs, "email", "email")

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs)
      assert "has invalid format" in errors_on(changeset).email
    end
  end

  describe "update_user/2" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "with valid data updates the user", %{user: user} do
      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, @valid_attrs)

      assert updated_user.name == @valid_attrs["name"]
      assert updated_user.email == @valid_attrs["email"]
      assert updated_user.login == @valid_attrs["login"]
      assert updated_user.type == @valid_attrs["type"]
      # assert updated_user.password == @valid_attrs["password"]
    end

    test "with invalid data returns error changeset", %{user: user} do
      update_attrs = %{
        "name" => nil,
        "login" => nil,
        "email" => nil,
        "type" => nil,
        "password" => nil
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.update_user(user, update_attrs)

      assert user == Accounts.get_user(user.id)

      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).login
      assert "can't be blank" in errors_on(changeset).password
      assert "can't be blank" in errors_on(changeset).type
    end

    test "with invalid email format error changeset", %{user: user} do
      update_attrs = %{"email" => "email"}

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.update_user(user, update_attrs)

      assert user == Accounts.get_user(user.id)

      assert "has invalid format" in errors_on(changeset).email
    end
  end

  describe "delete_user/2" do
    test "with valid data updates the user" do
      user = insert(:user)
      assert {:ok, %User{} = deleted_user} = Accounts.delete_user(user)
      assert deleted_user.id == user.id
      assert Accounts.get_user(user.id) == nil
    end
  end
end
