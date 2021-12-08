defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "initial" do
    v =
      "199
200
208
210
200
207
240
269
260
263"
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Day01.part_one()

    assert v == 7
  end

  test "part one" do
    v = parse_in() |> Day01.part_one()
    IO.puts("\npart one: #{v}")
  end

  test "part two initial" do
    v =
      "199
200
208
210
200
207
240
269
260
263"
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Day01.part_two()

    assert v == 5
  end

  test "part two" do
    v = parse_in() |> Day01.part_two()
    IO.puts("\npart two: #{v}")
  end

  def parse_in do
    File.read!("../inputs/day01.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
