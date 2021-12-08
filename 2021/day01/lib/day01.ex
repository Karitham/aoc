defmodule Day01 do
  def part_one([h | elems]) do
    done = is_bigger(h, hd(elems))
    if length(elems) > 1, do: done + part_one(elems), else: done
  end

  def part_one([]) do
    0
  end

  def is_bigger(old, new) do
    if new > old, do: 1, else: 0
  end

  def part_two(elems) do
    [_ | rest] = elems

    done = is_bigger(Enum.take(elems, 3) |> Enum.sum(), Enum.take(rest, 3) |> Enum.sum())

    if length(rest) > 3, do: done + part_two(rest), else: done
  end
end
