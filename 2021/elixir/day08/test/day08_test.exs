defmodule Day08Test do
  use ExUnit.Case

  defp inst do
    "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
    |> String.split("\n")
    |> Enum.map(fn v ->
      String.split(v, "|") |> Enum.map(&String.split(&1, ~r{\s+}, trim: true)) |> List.to_tuple()
    end)
  end

  defp input() do
    File.read!("../../inputs/day08.txt")
    |> String.split("\n")
    |> Enum.map(fn v ->
      String.split(v, "|")
      |> Enum.map(&String.split(&1, ~r{\s+}, trim: true))
      |> List.to_tuple()
    end)
  end

  test "part one instructions" do
    v = inst() |> Enum.reduce(0, fn {_, values}, acc -> Day08.count(values) + acc end)
    assert v == 26
  end

  test "part one" do
    v = input() |> Enum.reduce(0, fn {_, values}, acc -> Day08.count(values) + acc end)
    IO.puts("part one: #{v}")
  end

  test "part two instructions" do
    v =
      inst()
      |> Enum.reduce(0, fn {values, keys}, acc -> Day08.count_2({values, keys}) + acc end)

    assert v == 61229
  end

  test "part two" do
    v =
      input()
      |> Enum.reduce(0, fn {values, keys}, acc -> Day08.count_2({values, keys}) + acc end)

    IO.puts("part two: #{v}")
  end
end
