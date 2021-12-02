defmodule Day02Test do
  use ExUnit.Case

  def ex_inst do
    "forward 5
down 5
forward 8
up 3
down 8
forward 2"
  end

  test "part one instructions" do
    v =
      ex_inst()
      |> String.split("\n", trim: true)
      |> Enum.map(&Day02.parse_mv/1)
      |> Enum.reduce({0, 0}, fn inst_move, pos -> Day02.move(pos, inst_move) end)
      |> Day02.final_pos_p1()

    assert v == 150
  end

  test "part one" do
    v =
      parse_in()
      |> Enum.reduce({0, 0}, fn inst_move, pos -> Day02.move(pos, inst_move) end)
      |> Day02.final_pos_p1()

    IO.puts("\nPart 1: #{v}")
  end

  test "part two instructions" do
    v =
      ex_inst()
      |> String.split("\n", trim: true)
      |> Enum.map(&Day02.parse_mv/1)
      |> Enum.reduce({0, 0, 0}, fn inst_move, pos -> Day02.move_p2(pos, inst_move) end)
      |> Day02.final_pos_p2()

    assert v == 900
  end

  test "part two" do
    v =
      parse_in()
      |> Enum.reduce({0, 0, 0}, fn inst_move, pos -> Day02.move_p2(pos, inst_move) end)
      |> Day02.final_pos_p2()

    IO.puts("\nPart 2: #{v}")
  end

  def parse_in() do
    File.read!("../inputs/day02.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Day02.parse_mv/1)
  end
end
