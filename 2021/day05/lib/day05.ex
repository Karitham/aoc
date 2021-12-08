defmodule Day05 do
  def parse_input(input) do
    String.split(input, " -> ")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.concat()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def points({x1, y1, x2, y2}) when x1 == x2, do: Enum.map(y1..y2, &{x1, &1})
  def points({x1, y1, x2, y2}) when y1 == y2, do: Enum.map(x1..x2, &{&1, y1})
  def points(_), do: []

  def points_with_diag({x1, y1, x2, y2}) do
    points({x1, y1, x2, y2}) |> Enum.concat(Enum.zip(x1..x2, y1..y2)) |> Enum.uniq()
  end
end
