defmodule Arvore.Repo.Migrations.SeedUser do
  use Ecto.Migration

  alias Arvore.{Accounts.User, Repo}

  def up do
    if Mix.env() != :test do
      %User{
        id: 1,
        name: "user admin",
        type: "admin",
        entity_id: nil,
        login: "user_admin",
        email: "user_admin@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 2,
        name: "user admin 2",
        type: "admin",
        entity_id: nil,
        login: "user_admin_2",
        email: "user_admin_2@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 3,
        name: "user network",
        type: "entity",
        entity_id: 1,
        login: "user_network",
        email: "user_network@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 4,
        name: "user network 2",
        type: "entity",
        entity_id: 1,
        login: "user_network_2",
        email: "user_network_2@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 5,
        name: "user network 3",
        type: "entity",
        entity_id: 2,
        login: "user_network_3",
        email: "user_network_3@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 6,
        name: "user network 4",
        type: "entity",
        entity_id: 2,
        login: "user_network_4",
        email: "user_network_4@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 7,
        name: "user school",
        type: "entity",
        entity_id: 3,
        login: "user_school",
        email: "user_school@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 8,
        name: "user school 2",
        type: "entity",
        entity_id: 3,
        login: "user_school_2",
        email: "user_school_2@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 9,
        name: "user school 3",
        type: "entity",
        entity_id: 4,
        login: "user_school_3",
        email: "user_school_3@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 10,
        name: "user school 4",
        type: "entity",
        entity_id: 4,
        login: "user_school_4",
        email: "user_school_4@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 11,
        name: "user school 5",
        type: "entity",
        entity_id: 5,
        login: "user_school_5",
        email: "user_school_5@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 12,
        name: "user school 6",
        type: "entity",
        entity_id: 5,
        login: "user_school_6",
        email: "user_school_6@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 13,
        name: "user school 7",
        type: "entity",
        entity_id: 6,
        login: "user_school_7",
        email: "user_school_7@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 14,
        name: "user school 8",
        type: "entity",
        entity_id: 6,
        login: "user_school_8",
        email: "user_school_8@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 15,
        name: "user class",
        type: "entity",
        entity_id: 7,
        login: "user_class",
        email: "user_class@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 16,
        name: "user class 02",
        type: "entity",
        entity_id: 7,
        login: "user_class_02",
        email: "user_class_02@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 17,
        name: "user class 03",
        type: "entity",
        entity_id: 8,
        login: "user_class_03",
        email: "user_class_03@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 18,
        name: "user class 04",
        type: "entity",
        entity_id: 8,
        login: "user_class_04",
        email: "user_class_04@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 19,
        name: "user class 05",
        type: "entity",
        entity_id: 9,
        login: "user_class_05",
        email: "user_class_05@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 20,
        name: "user class 06",
        type: "entity",
        entity_id: 9,
        login: "user_class_06",
        email: "user_class_06@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 21,
        name: "user class 07",
        type: "entity",
        entity_id: 10,
        login: "user_class_07",
        email: "user_class_07@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 22,
        name: "user class 08",
        type: "entity",
        entity_id: 10,
        login: "user_class_08",
        email: "user_class_08@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 23,
        name: "user class 09",
        type: "entity",
        entity_id: 11,
        login: "user_class_09",
        email: "user_class_09@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 24,
        name: "user class 10",
        type: "entity",
        entity_id: 11,
        login: "user_class_10",
        email: "user_class_10@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 25,
        name: "user class 11",
        type: "entity",
        entity_id: 12,
        login: "user_class_11",
        email: "user_class_11@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 26,
        name: "user class 12",
        type: "entity",
        entity_id: 12,
        login: "user_class_12",
        email: "user_class_12@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 27,
        name: "user class 13",
        type: "entity",
        entity_id: 13,
        login: "user_class_13",
        email: "user_class_13@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 28,
        name: "user class 14",
        type: "entity",
        entity_id: 13,
        login: "user_class_14",
        email: "user_class_14@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 29,
        name: "user class 15",
        type: "entity",
        entity_id: 14,
        login: "user_class_15",
        email: "user_class_15@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()

      %User{
        id: 30,
        name: "user class 16",
        type: "entity",
        entity_id: 14,
        login: "user_class_16",
        email: "user_class_16@email.com",
        password: Bcrypt.hash_pwd_salt("senha")
      }
      |> Repo.insert!()
    end
  end

  def down do
    if Mix.env() != :test do
      Repo.delete_all(Entity)
    end
  end
end
