defmodule Game.Command.Use do
  @moduledoc """
  The "use" command
  """

  use Game.Command

  alias Game.Character
  alias Game.Effect
  alias Game.Item
  alias Game.Items

  commands ["use"]

  def help(:topic), do: "Use"
  def help(:short), do: "Use an item from your inventory"
  def help(:full) do
    """
    #{help(:short)}

    Example:
    [ ] > {white}use potion{/white}
    """
  end

  @doc """
  Use an item
  """
  @spec run(args :: [], session :: Session.t, state :: map) :: :ok
  def run(command, session, state)
  def run({item_name}, _session, state = %{socket: socket, save: %{items: items}}) do
    items = Items.items(items)
    case Item.find_item(items, item_name) do
      nil -> socket |> item_not_found(item_name)
      item -> state |> use_item(item)
    end
  end

  defp item_not_found(socket, item_name) do
    socket |> @socket.echo(~s("#{item_name}" could not be found."))
    :ok
  end

  defp use_item(%{user: user, save: save}, item) do
    wearing_effects = save |> Item.effects_from_wearing(only: ["stats"])
    wielding_effects = save |> Item.effects_from_wielding(only: ["stats"])
    effects = save.stats |> Effect.calculate(wearing_effects ++ wielding_effects ++ item.effects)
    Character.apply_effects({:user, user}, effects, {:user, user}, Format.use_item(item))
    :ok
  end
end