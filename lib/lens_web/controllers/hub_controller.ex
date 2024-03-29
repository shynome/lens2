defmodule LensWeb.HubController do
  use LensWeb, :controller

  alias Lens.Signaler
  alias Lens.Signaler.Hub
  alias LensWeb.Signaler.Event
  alias Phoenix.Socket.Broadcast

  plug :auth when action not in [:options]
  plug :check_pass when action in [:index]

  action_fallback LensWeb.FallbackController

  def index(%{assigns: %{room: room}} = conn, _params) do
    :ok = LensWeb.Endpoint.subscribe(room)
    :timer.send_interval(5_000, {:keep_alive})

    conn
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    |> send_comment()
    |> send_tasks()
  end

  defp send_comment(conn, comment \\ ": a hack comment for pass caddy\n") do
    conn |> chunk(comment <> "\n")
    conn
  end

  defp send_tasks(conn) do
    receive do
      %Broadcast{} = msg ->
        e = %Event{event: msg.topic, id: msg.event, data: "#{msg.payload}"}
        conn |> chunk("#{e}")

      {:keep_alive} ->
        conn |> send_comment()
    end

    send_tasks(conn)
  end

  def create(%{assigns: %{room: room}} = conn, _params) do
    tid = UUID.uuid4()
    :ok = LensWeb.Endpoint.subscribe(tid)

    {:ok, body, _} = read_body(conn)
    LensWeb.Endpoint.broadcast!(room, tid, body)

    receive do
      %Broadcast{payload: body} ->
        conn
        |> put_resp_content_type("application/octet-stream")
        |> send_resp(200, body)
    end
  end

  def delete(conn, _params) do
    [tid | _] = get_req_header(conn, "x-csrf-token")
    {:ok, body, _} = read_body(conn)

    LensWeb.Endpoint.broadcast!(tid, "resp", body)

    conn
    |> send_resp(204, "")
  end

  def options(conn, _params) do
    conn
    |> send_resp(204, "")
  end

  defp auth(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         %{"t" => topic} <- conn.params do
      conn
      |> assign(:room, "#{user}-#{topic}")
      |> assign(:user, "#{user}")
      |> assign(:pass, "#{pass}")
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end

  defp check_pass(%{assigns: %{user: user, pass: pass}} = conn, _opts) do
    {_luser, lpass} = Hub.get(user, pass)

    if lpass != pass do
      conn |> send_resp(403, "") |> halt()
    else
      conn
    end
  end
end
