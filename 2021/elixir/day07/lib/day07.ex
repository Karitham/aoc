defmodule Day07 do
  defp diff(x, y), do: abs(x - y)

  def min_sum(l) when is_list(l) do
    Enum.reduce(Enum.max(l)..0, 1_000_000_000_000_000_000_000, fn n, acc ->
      s = Enum.map(l, &diff(&1, n)) |> Enum.sum()
      if s < acc, do: s, else: acc
    end)
  end

  def min_sum_p2(l) when is_list(l) do
    Enum.reduce(Enum.max(l)..0, 1_000_000_000_000_000_000_000, fn n, acc ->
      s = Enum.map(l, &round(diff(&1, n) * (diff(&1, n) + 1) / 2)) |> Enum.sum()
      if s < acc, do: s, else: acc
    end)
  end
end
