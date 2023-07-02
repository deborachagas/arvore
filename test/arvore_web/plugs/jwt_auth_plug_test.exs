defmodule ArvoreWeb.JwtAuthPlugTest do
  use ArvoreWeb.ConnCase

  alias ArvoreWeb.JwtAuthPlug

  import Mock

  alias Arvore.Accounts.ArvoreToken
  alias Phoenix.Controller
  alias Plug.Conn

  describe "call/2" do
    test "succes validate jwt and assign claims and jwt to conn", %{conn: conn} do
      with_mocks [
        {Conn, [],
         [
           get_req_header: fn _, _ -> ["Bearer token"] end,
           put_private: fn conn, _, _ -> conn end,
           assign: fn conn, key, val ->
             assigns = Map.get(conn, :assigns, %{})
             assigns = Map.put(assigns, key, val)
             Map.put(conn, :assigns, assigns)
           end,
           halt: fn conn -> conn end
         ]},
        {ArvoreToken, [], [verify: fn _, _ -> {:ok, %{claims: %{"sub" => 1}}} end]},
        {Controller, [],
         [
           put_view: fn conn, _ -> conn end,
           render: fn conn, _, _ -> conn end
         ]}
      ] do
        jwt_validate = JwtAuthPlug.call(conn, nil)
        assert jwt_validate.status == nil
        assert jwt_validate.assigns.jwt == "token"
        assert jwt_validate.assigns.claims == %{claims: %{"sub" => 1}}
      end
    end

    test "returns error when jwt is nil", %{conn: conn} do
      with_mocks [
        {Conn, [],
         [
           get_req_header: fn _, _ -> ["Bearer token"] end,
           put_status: fn conn, _ -> Map.put(conn, :status, 401) end,
           put_private: fn conn, _, _ -> conn end,
           halt: fn conn -> conn end
         ]},
        {Controller, [],
         [
           put_view: fn conn, _ -> conn end,
           render: fn conn, _, _ ->
             Map.put(conn, :assigns, %{layout: false, message: "Forbidden"})
           end
         ]}
      ] do
        jwt_validate = JwtAuthPlug.call(conn, nil)
        assert jwt_validate.status == 401
        assert jwt_validate.assigns == %{layout: false, message: "Forbidden"}
      end
    end

    test "returns error when a generic error", %{conn: conn} do
      with_mocks [
        {Conn, [],
         [
           get_req_header: fn _, _ -> [] end,
           put_status: fn conn, _ -> Map.put(conn, :status, 401) end,
           put_private: fn conn, _, _ -> conn end,
           halt: fn conn -> conn end
         ]},
        {ArvoreToken, [], [verify: fn _, _ -> :error end]},
        {Controller, [],
         [
           put_view: fn conn, _ -> conn end,
           render: fn conn, _, _ ->
             Map.put(conn, :assigns, %{layout: false, message: "Forbidden"})
           end
         ]}
      ] do
        jwt_validate = JwtAuthPlug.call(conn, nil)
        assert jwt_validate.status == 401
        assert jwt_validate.assigns == %{layout: false, message: "Forbidden"}
      end
    end
  end
end
