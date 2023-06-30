defmodule ArvoreWeb.V1.Accounts.UserView do
  use ArvoreWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      login: user.login,
      email: user.email,
      type: user.type
    }
  end
end
