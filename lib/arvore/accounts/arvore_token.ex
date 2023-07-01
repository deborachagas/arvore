defmodule Arvore.Accounts.ArvoreToken do
  use Joken.Config, default_signer: :pem_rs256

  @impl Joken.Config
  def token_config do
    default_claims(default_exp: 60 * 60, iss: "arvore", aud: "user")
    # |> add_claim("role", fn -> "USER" end, &(&1 in ["ADMIN", "USER"]))
  end

  @impl Joken.Config
  def encode_and_sign(user, _) do
    extra_claims = %{"sub" => user.id, "user_login" => user.login, "user_type" => user.type}
    Joken.generate_and_sign(token_config(), extra_claims, signer())
  end

  @impl Joken.Config
  def verify(jwt, _) do
    Joken.verify_and_validate(token_config(), jwt, signer())
  end

  defp signer, do: Joken.Signer.create("HS256", jwt_secret())
  defp jwt_secret, do: Application.get_env(:arvore, :jwt_secret)
end
