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
    v =
      File.read!("../inputs/day1.txt")
      |> String.split("\n")
      |> Enum.map(fn x ->
        {i, _} = Integer.parse(x)
        i
      end)
      |> Enum.reduce(0, fn x, acc -> acc + Day1.partOne(x) end)

    assert v == 3_216_868

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
    v =
      File.read!("../inputs/day1.txt")
      |> String.split("\n")
      |> Enum.map(fn x ->
        {i, _} = Integer.parse(x)
        i
      end)
      |> Enum.reduce(0, fn x, acc -> acc + Day1.partTwo(x) end)

    assert v == 4_822_435

    IO.puts("\nPart two: #{v}")
  end
end
