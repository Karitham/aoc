defmodule Day06Test do
  use ExUnit.Case

  defp inst do
    "3,4,3,1,2" |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  defp input do
    File.read!("../inputs/day06.txt") |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  test "part one instructions", do: assert(Day06.fish_in_days(inst(), 80) == 5934)
  test "part one", do: IO.puts("part one: #{Day06.fish_in_days(input(), 80)}")

  test "part two instructions", do: assert(Day06.fish_in_days(inst(), 256) == 26_984_457_539)
  test "part two", do: IO.puts("part two: #{Day06.fish_in_days(input(), 256)}")
end
