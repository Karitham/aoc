defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "initial test" do
    assert Day1.partOne(12) == 2
  end

  test "initial 14" do
    assert Day1.partOne(14) == 2
  end

  test "initial 1969" do
    assert Day1.partOne(1969) == 654
  end

  test "initial 100756" do
    assert Day1.partOne(100_756) == 33583
  end

  test "whole test" do
    v = parse_in() |> Enum.reduce(0, fn x, acc -> acc + Day1.partOne(x) end)

    IO.puts("\nPart one: #{v}")
  end

  test "part 2 12" do
    assert Day1.partTwo(12) == 2
  end

  test "part 2 1969" do
    assert Day1.partTwo(1969) == 966
  end

  test "part 2 100756" do
    assert Day1.partTwo(100_756) == 50346
  end

  test "part 2" do
    v = parse_in() |> Enum.reduce(0, fn x, acc -> acc + Day1.partTwo(x) end)

    IO.puts("\nPart two: #{v}")
  end

  def parse_in do
    File.read!("../inputs/day1.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
