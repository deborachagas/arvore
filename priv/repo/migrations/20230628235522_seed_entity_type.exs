defmodule Arvore.Repo.Migrations.SeedEntityType do
  use Ecto.Migration

  alias Arvore.{EntityType, Repo}
  @types ["Network", "School", "Class"]

  def change do
    for name <- @types do
      Repo.insert!(%EntityType{name: name})
    end
  end
end
