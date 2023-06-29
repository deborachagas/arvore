defmodule ArvoreWeb.HealthCheckController do
  use ArvoreWeb, :controller

  def health(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end
