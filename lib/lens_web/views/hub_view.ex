defmodule LensWeb.HubView do
  use LensWeb, :view
  alias LensWeb.HubView

  def render("index.json", %{api: api}) do
    %{data: render_many(api, HubView, "hub.json")}
  end

  def render("show.json", %{hub: hub}) do
    %{data: render_one(hub, HubView, "hub.json")}
  end

  def render("hub.json", %{hub: hub}) do
    %{
      id: hub.id
    }
  end
end
