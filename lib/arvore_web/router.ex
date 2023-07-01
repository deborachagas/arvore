defmodule ArvoreWeb.Router do
  use ArvoreWeb, :router

  pipeline :unauthorize do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ArvoreWeb.JwtAuthPlug
  end

  scope "/", ArvoreWeb do
    get "/health", HealthCheckController, :health
  end

  scope "/api", ArvoreWeb do
    pipe_through :unauthorize

    scope "/v1", V1 do
      scope "/accounts", Accounts do
        post "/login", AuthenticationController, :login
      end
    end
  end

  scope "/api", ArvoreWeb do
    pipe_through :api

    scope "/v1", V1 do
      scope "/accounts", Accounts do
        resources "/users", UserController
      end
    end

    scope "/v2", V2 do
      scope "/partners", Partners do
        resources "/entities", EntityController
      end
    end
  end
end
