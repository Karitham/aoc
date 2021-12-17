defmodule Day04Test do
  use ExUnit.Case

  defp inst do
    "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"
  end

  test "part one instructions" do
    [inpts | bd] = inst() |> String.split(~r/[\r\n]{2,}/, trim: true)
    inputs = inpts |> String.split(",")

    boards =
      bd
      |> Enum.map(fn e ->
        String.split(e, "\n")
        |> Enum.map(fn l ->
          String.split(l, ~r{\s+}, trim: true)
        end)
      end)

    elems =
      boards
      |> Enum.map(fn b -> Day04.get_first_matching(b, inputs) end)

    lens = Enum.map(elems, &length/1)
    min = Enum.min(lens)
    min_elems = Enum.find(elems, fn e -> length(e) == min end)

    board_index =
      elems
      |> Enum.find_index(fn e -> length(e) == min end)

    board = Enum.at(boards, board_index)

    # Filter all in the board that was not checked
    sum_unchecked =
      Enum.map(board, fn row ->
        Enum.filter(row, fn el ->
          !Enum.any?(min_elems, fn e ->
            e == el
          end)
        end)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
      end)
      |> Enum.sum()

    # last bingo number found
    last_el = List.last(min_elems) |> String.to_integer()

    assert sum_unchecked * last_el == 4512
  end

  test "part one" do
    [inpts | bd] =
      File.read!("../../inputs/day04.txt") |> String.split(~r/[\r\n]{2,}/, trim: true)

    inputs = inpts |> String.split(",")

    boards =
      bd
      |> Enum.map(fn e ->
        String.split(e, "\n")
        |> Enum.map(fn l ->
          String.split(l, ~r{\s+}, trim: true)
        end)
      end)

    elems =
      boards
      |> Enum.map(fn b -> Day04.get_first_matching(b, inputs) end)

    lens = Enum.map(elems, &length/1)
    min = Enum.min(lens)
    min_elems = Enum.find(elems, fn e -> length(e) == min end)

    board_index =
      elems
      |> Enum.find_index(fn e -> length(e) == min end)

    board = Enum.at(boards, board_index)

    # Filter all in the board that was not checked
    sum_unchecked =
      Enum.map(board, fn row ->
        Enum.filter(row, fn el ->
          !Enum.any?(min_elems, fn e ->
            e == el
          end)
        end)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
      end)
      |> Enum.sum()

    # last bingo number found
    last_el = List.last(min_elems) |> String.to_integer()

    IO.puts("Part one: #{sum_unchecked * last_el}")
  end

  test "part two instructions" do
    [inpts | bd] = inst() |> String.split(~r/[\r\n]{2,}/, trim: true)
    inputs = inpts |> String.split(",")

    boards =
      bd
      |> Enum.map(fn e ->
        String.split(e, "\n")
        |> Enum.map(fn l ->
          String.split(l, ~r{\s+}, trim: true)
        end)
      end)

    elems =
      boards
      |> Enum.map(fn b -> Day04.get_first_matching(b, inputs) end)

    lens = Enum.map(elems, &length/1)
    max = Enum.max(lens)
    max_elems = Enum.find(elems, fn e -> length(e) == max end)

    board_index =
      elems
      |> Enum.find_index(fn e -> length(e) == max end)

    board = Enum.at(boards, board_index)

    # Filter all in the board that was not checked
    sum_unchecked =
      Enum.map(board, fn row ->
        Enum.filter(row, fn el ->
          !Enum.any?(max_elems, fn e ->
            e == el
          end)
        end)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
      end)
      |> Enum.sum()

    # last bingo number found
    last_el = List.last(max_elems) |> String.to_integer()

    assert sum_unchecked * last_el == 1924
  end

  test "part two" do
    [inpts | bd] =
      File.read!("../../inputs/day04.txt") |> String.split(~r/[\r\n]{2,}/, trim: true)

    inputs = inpts |> String.split(",")

    boards =
      bd
      |> Enum.map(fn e ->
        String.split(e, "\n")
        |> Enum.map(fn l ->
          String.split(l, ~r{\s+}, trim: true)
        end)
      end)

    elems =
      boards
      |> Enum.map(fn b -> Day04.get_first_matching(b, inputs) end)

    lens = Enum.map(elems, &length/1)
    max = Enum.max(lens)
    max_elems = Enum.find(elems, fn e -> length(e) == max end)

    board_index =
      elems
      |> Enum.find_index(fn e -> length(e) == max end)

    board = Enum.at(boards, board_index)

    # Filter all in the board that was not checked
    sum_unchecked =
      Enum.map(board, fn row ->
        Enum.filter(row, fn el ->
          !Enum.any?(max_elems, fn e ->
            e == el
          end)
        end)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
      end)
      |> Enum.sum()

    # last bingo number found
    last_el = List.last(max_elems) |> String.to_integer()

    IO.puts("Part two: #{sum_unchecked * last_el}")
  end
end
