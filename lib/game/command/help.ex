defmodule Game.Command.Help do
  @moduledoc """
  The "help" command
  """

  use Game.Command

  alias Game.Help

  @doc """
  View help
  """
  @spec run([topic :: String.t], session :: Session.t, state :: map) :: :ok
  def run([], _session, %{socket: socket}) do
    socket |> @socket.echo(Help.base)
    :ok
  end
  def run([topic], _session, %{socket: socket}) do
    socket |> @socket.echo(Help.topic(topic))
    :ok
  end
end