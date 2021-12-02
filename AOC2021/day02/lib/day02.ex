defmodule Day02 do
  def move({y, x}, {inst, n}) do
    case inst do
      :forward -> {y, x + n}
      :down -> {y + n, x}
      :up -> {y - n, x}
      _ -> raise "Unknown instruction: #{inst}"
    end
  end

  def move_p2({y, x, aim}, {inst, n}) do
    case inst do
      :forward -> {y + aim * n, x + n, aim}
      :down -> {y, x, aim + n}
      :up -> {y, x, aim - n}
      _ -> raise "Unknown instruction: #{inst}"
    end
  end

  def parse_mv(line) do
    [inst, mv] = String.split(line, ~r{\s+})

    into_inst(inst, mv)
  end

  def final_pos_p1({y, x}) do
    x * y
  end

  def final_pos_p2({y, x, _}) do
    x * y
  end

  def into_inst(inst, mv) do
    case inst do
      "forward" -> {:forward, String.to_integer(mv)}
      "down" -> {:down, String.to_integer(mv)}
      "up" -> {:up, String.to_integer(mv)}
    end
  end
end
