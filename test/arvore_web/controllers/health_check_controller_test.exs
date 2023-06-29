defmodule ArvoreWeb.HealthCheckControllerTest do
  @moduledoc false
  use ArvoreWeb.ConnCase, async: true

  describe "GET /health" do
    test "returns 200", %{conn: conn} do
      %{resp_body: response} =
        conn
        |> get(Routes.health_check_path(conn, :health))

      assert response == "ok"
    end
  end
end
