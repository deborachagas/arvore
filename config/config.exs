# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :arvore,
  ecto_repos: [Arvore.Repo]

# Configures the endpoint
config :arvore, ArvoreWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ArvoreWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Arvore.PubSub,
  live_view: [signing_salt: "wzuMxz7V"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :arvore, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: ArvoreWeb.Router,
      endpoint: ArvoreWeb.Endpoint
    ]
  }
