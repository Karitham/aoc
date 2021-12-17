defmodule Day07Test do
  use ExUnit.Case

  defp inst, do: "16,1,2,0,4,2,7,1,2,14" |> String.split(",") |> Enum.map(&String.to_integer/1)

  defp input,
    do:
      File.read!("../../inputs/day07.txt") |> String.split(",") |> Enum.map(&String.to_integer/1)

  test "part one instructions", do: assert(inst() |> Day07.min_sum() == 37)
  test "part one", do: IO.puts("part one: #{input() |> Day07.min_sum()}")
  test "part two instructions", do: assert(inst() |> Day07.min_sum_p2() == 168)
  test "part two", do: IO.puts("part two: #{input() |> Day07.min_sum_p2()}")
end
