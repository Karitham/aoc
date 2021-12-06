defmodule Day06 do
  def fish_in_days(list, max) do
    fish_in_days(
      Enum.reduce(
        list,
        %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0},
        fn e, m -> Map.update!(m, e, &(&1 + 1)) end
      ),
      0,
      max
    )
    |> Enum.reduce(0, fn {_, v}, acc -> v + acc end)
  end

  def fish_in_days(m, index, max) when index < max do
    # Remove old
    {f, m} = Map.get_and_update!(m, 0, fn v -> {v, 0} end)

    m = Enum.reduce(0..8, m, &Map.update!(&2, &1, fn _ -> &2[&1 + 1] end))

    # New fishes
    m = Map.update!(m, 6, fn _ -> m[6] + f end)
    m = Map.update!(m, 8, fn _ -> f end)

    fish_in_days(m, index + 1, max)
  end

  def fish_in_days(m, _, _), do: m
end
