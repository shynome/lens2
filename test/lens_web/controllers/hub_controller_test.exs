defmodule LensWeb.HubControllerTest do
  use LensWeb.ConnCase

  import Lens.SignalerFixtures

  alias Lens.Signaler.Hub

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all api", %{conn: conn} do
      conn = get(conn, Routes.hub_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create hub" do
    test "renders hub when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hub_path(conn, :create), hub: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.hub_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hub_path(conn, :create), hub: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update hub" do
    setup [:create_hub]

    test "renders hub when data is valid", %{conn: conn, hub: %Hub{id: id} = hub} do
      conn = put(conn, Routes.hub_path(conn, :update, hub), hub: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.hub_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, hub: hub} do
      conn = put(conn, Routes.hub_path(conn, :update, hub), hub: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete hub" do
    setup [:create_hub]

    test "deletes chosen hub", %{conn: conn, hub: hub} do
      conn = delete(conn, Routes.hub_path(conn, :delete, hub))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.hub_path(conn, :show, hub))
      end
    end
  end

  defp create_hub(_) do
    hub = hub_fixture()
    %{hub: hub}
  end
end
