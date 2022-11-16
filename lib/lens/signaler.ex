defmodule Lens.Signaler do
  @moduledoc """
  The Signaler context.
  """
end

defmodule Lens.Signaler.Hub do
  use GenServer

  @name __MODULE__

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    :ets.new(@name, [:set, :protected, :named_table])
    {:ok, []}
  end

  def get(user, pass) do
    case :ets.lookup(@name, user) do
      [] ->
        :ok = GenServer.call(__MODULE__, {:create, {user, pass}})
        {user, pass}

      [{user, pass} | _] ->
        {user, pass}
    end
  end

  def handle_call({:create, {user, pass}}, _ref, state) do
    true = :ets.insert_new(@name, {user, pass})
    {:reply, :ok, state}
  end
end

defmodule LensWeb.Signaler.Event do
  defstruct [
    :id,
    :event,
    :data
  ]
end

defimpl String.Chars, for: LensWeb.Signaler.Event do
  alias LensWeb.Signaler.Event

  def to_string(%Event{} = ev) do
    s = ""
    s = s <> "id: #{ev.id}\n"
    s = s <> "data: #{ev.data}\n"
    s = if String.length(ev.event) > 0, do: s <> "event: #{ev.event}\n", else: s
    s = s <> "\n"
    s
  end
end
