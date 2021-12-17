defmodule Day05Test do
  use ExUnit.Case

  defp inst do
    "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2" |> String.split("\n")
  end

  defp input do
    File.read!("../../inputs/day05.txt") |> String.split("\n", trim: true)
  end

  test "part one instructions" do
    v =
      inst()
      |> Enum.map(&Day05.parse_input/1)
      |> Enum.map(&Day05.points/1)
      |> Enum.concat()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.count(&(&1 > 1))

    assert v == 5
  end

  test "part one" do
    v =
      input()
      |> Enum.map(&Day05.parse_input/1)
      |> Enum.map(&Day05.points/1)
      |> Enum.concat()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.count(&(&1 > 1))

    IO.puts("part one: #{v}")
  end

  test "part two instructions" do
    v =
      inst()
      |> Enum.map(&Day05.parse_input/1)
      |> Enum.map(&Day05.points_with_diag/1)
      |> Enum.concat()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.count(&(&1 > 1))

    assert v == 12
  end

  test "part two" do
    v =
      input()
      |> Enum.map(&Day05.parse_input/1)
      |> Enum.map(&Day05.points_with_diag/1)
      |> Enum.concat()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.count(&(&1 > 1))

    IO.puts("part two: #{v}")
  end

  test "points_with_diag" do
    assert Day05.points_with_diag({1, 1, 3, 3}) == [{1, 1}, {2, 2}, {3, 3}]
    assert Day05.points_with_diag({9, 7, 7, 9}) == [{9, 7}, {8, 8}, {7, 9}]

    assert Day05.points_with_diag({0, 0, 0, 0}) == [{0, 0}]

    assert Day05.points_with_diag({0, 0, 8, 8}) == [
             {0, 0},
             {1, 1},
             {2, 2},
             {3, 3},
             {4, 4},
             {5, 5},
             {6, 6},
             {7, 7},
             {8, 8}
           ]
  end

  test "points" do
    assert Day05.points({1, 1, 1, 3}) == [{1, 1}, {1, 2}, {1, 3}]
    assert Day05.points({9, 7, 7, 7}) == [{9, 7}, {8, 7}, {7, 7}]
    assert Day05.points({0, 0, 8, 8}) == []
    assert Day05.points({0, 0, 0, 0}) == [{0, 0}]
    assert Day05.points({0, 9, 5, 9}) == [{0, 9}, {1, 9}, {2, 9}, {3, 9}, {4, 9}, {5, 9}]
  end
end
