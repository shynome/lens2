defmodule Lens.SignalerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lens.Signaler` context.
  """

  @doc """
  Generate a hub.
  """
  def hub_fixture(attrs \\ %{}) do
    {:ok, hub} =
      attrs
      |> Enum.into(%{

      })
      |> Lens.Signaler.create_hub()

    hub
  end
end
