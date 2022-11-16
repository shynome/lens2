defmodule Lens.SignalerTest do
  use Lens.DataCase

  alias Lens.Signaler

  describe "api" do
    alias Lens.Signaler.Hub

    import Lens.SignalerFixtures

    @invalid_attrs %{}

    test "list_api/0 returns all api" do
      hub = hub_fixture()
      assert Signaler.list_api() == [hub]
    end

    test "get_hub!/1 returns the hub with given id" do
      hub = hub_fixture()
      assert Signaler.get_hub!(hub.id) == hub
    end

    test "create_hub/1 with valid data creates a hub" do
      valid_attrs = %{}

      assert {:ok, %Hub{} = hub} = Signaler.create_hub(valid_attrs)
    end

    test "create_hub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Signaler.create_hub(@invalid_attrs)
    end

    test "update_hub/2 with valid data updates the hub" do
      hub = hub_fixture()
      update_attrs = %{}

      assert {:ok, %Hub{} = hub} = Signaler.update_hub(hub, update_attrs)
    end

    test "update_hub/2 with invalid data returns error changeset" do
      hub = hub_fixture()
      assert {:error, %Ecto.Changeset{}} = Signaler.update_hub(hub, @invalid_attrs)
      assert hub == Signaler.get_hub!(hub.id)
    end

    test "delete_hub/1 deletes the hub" do
      hub = hub_fixture()
      assert {:ok, %Hub{}} = Signaler.delete_hub(hub)
      assert_raise Ecto.NoResultsError, fn -> Signaler.get_hub!(hub.id) end
    end

    test "change_hub/1 returns a hub changeset" do
      hub = hub_fixture()
      assert %Ecto.Changeset{} = Signaler.change_hub(hub)
    end
  end
end
