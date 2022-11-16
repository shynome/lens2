defmodule Lens.Signaler do
  @moduledoc """
  The Signaler context.
  """
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
