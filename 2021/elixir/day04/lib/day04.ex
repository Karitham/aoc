defmodule Day04 do
  def get_first_matching(board, elems) do
    cols = Enum.zip(board) |> Enum.map(&Tuple.to_list/1)
    get_first_matching(board, cols, elems, 0)
  end

  defp get_first_matching(rows, cols, elems, index) do
    if index == length(elems), do: {:halt, nil}

    case get_first_matching(rows, cols, Enum.slice(elems, 0, index)) do
      {:continue} -> get_first_matching(rows, cols, elems, index + 1)
      {:halt} -> Enum.slice(elems, 0, index)
    end
  end

  defp get_first_matching(rows, cols, elems) do
    cond do
      rows |> line_matches(elems) ->
        {:halt}

      cols |> line_matches(elems) ->
        {:halt}

      true ->
        {:continue}
    end
  end

  defp line_matches(line, elems) do
    line
    |> Enum.any?(fn row ->
      Enum.all?(row, fn elem ->
        Enum.any?(elems, fn e ->
          e == elem
        end)
      end)
    end)
  end
end
