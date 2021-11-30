defmodule Day1 do
  def partOne(x) do
    floor(x / 3) - 2
  end

  def partTwo(x) do
    p1 = partOne(x)

    if p1 > 0,
      do: partTwo(p1, p1),
      else: p1
  end

  def partTwo(x, acc) do
    p1 = partOne(x)

    if p1 > 0,
      do: partTwo(p1, acc + p1),
      else: acc
  end
end
