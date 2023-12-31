defmodule ArvoreWeb.Router do
  use ArvoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ArvoreWeb.JwtAuthPlug
  end

  scope "/", ArvoreWeb do
    get "/health", HealthCheckController, :health
  end

  scope "/" do
    pipe_through [:api, :auth]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ArvoreWeb.Schema,
      interface: :simple,
      context: %{pubsub: ArvoreWeb.Endpoint}
  end

  scope "/api", ArvoreWeb do
    pipe_through :api

    scope "/v1", V1 do
      scope "/accounts", Accounts do
        post "/login", AuthenticationController, :login
        resources "/users", UserController, only: [:create]
      end
    end
  end

  scope "/api", ArvoreWeb do
    pipe_through [:api, :auth]

    scope "/v1", V1 do
      scope "/accounts", Accounts do
        resources "/users", UserController, only: [:index, :show, :update, :delete]
        get "/me", UserController, :me
      end
    end

    scope "/v2", V2 do
      scope "/partners", Partners do
        resources "/entities", EntityController
      end
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :arvore,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      schemes: ["http", "https"],
      info: %{
        version: "1.0",
        title: "API Árvore",
        description: "API Documentation for Árvore v2",
        contact: %{
          name: "Débora Chagas",
          email: "deb.chagas@gmail.com"
        }
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "API JWT Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Entity", description: "Entity resources"}
      ]
    }
  end
end
