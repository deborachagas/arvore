defmodule Arvore.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Arvore.Repo

  use Arvore.Partners.{
    EntityFactory,
    EntityTypeFactory
  }
end
