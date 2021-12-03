defmodule Day03Test do
  use ExUnit.Case
  use Bitwise

  doctest Day03

  def inst do
    "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
    |> String.split("\n")
  end

  test "part one instructions" do
    v =
      inst()
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      # e is {"0","1"}...
      |> Enum.reduce([], fn e, m ->
        f = Enum.frequencies(Tuple.to_list(e))

        if f["0"] > f["1"] do
          m ++ ["0"]
        else
          m ++ ["1"]
        end
      end)

    n = String.to_integer(to_string(v), 2)

    # I hate this...
    assert n * (:math.pow(2, length(v)) - n - 1) == 198
  end

  test "part one" do
    v =
      File.read!("../inputs/day03.txt")
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      # e is {"0","1"}...
      |> Enum.reduce([], fn e, m ->
        f = Enum.frequencies(Tuple.to_list(e))

        if f["0"] > f["1"] do
          m ++ ["0"]
        else
          m ++ ["1"]
        end
      end)

    n = String.to_integer(to_string(v), 2)

    # I hate this...
    IO.puts("part one: #{n * (:math.pow(2, length(v)) - n - 1)}")
  end

  test "part two instructions" do
    v_ogr = inst() |> Day03.find_closest_prefix_ogr() |> to_string()
    v_co2sr = inst() |> Day03.find_closest_prefix_co2() |> to_string()

    assert String.to_integer(v_co2sr, 2) * String.to_integer(v_ogr, 2) == 230
  end

  test "part two" do
    inst =
      File.read!("../inputs/day03.txt")
      |> String.split("\n")

    v_ogr = inst |> Day03.find_closest_prefix_ogr() |> to_string()
    v_co2sr = inst |> Day03.find_closest_prefix_co2() |> to_string()

    IO.puts("part two: #{String.to_integer(v_co2sr, 2) * String.to_integer(v_ogr, 2)}")
  end
end
