defmodule Day08 do
  defp len(s), do: String.length(s)
  defp appnd_n(n, x), do: String.to_integer(Integer.to_string(n) <> Integer.to_string(x))

  def count(values) when is_list(values), do: values |> Enum.reduce(0, &(is_1_4_7_8?(&1) + &2))

  defp is_1_4_7_8?(s) do
    case len(s) do
      2 -> 1
      3 -> 1
      4 -> 1
      7 -> 1
      _ -> 0
    end
  end

  def count_2({values, keys}) when is_list(values) do
    one = values |> Enum.find(&(len(&1) == 2))
    seven = values |> Enum.find(&(len(&1) == 3))
    four = values |> Enum.find(&(len(&1) == 4))
    eight = values |> Enum.find(&(len(&1) == 7))
    nine = values |> Enum.find(&(len(&1) == 6 && contains_exactly?(four, &1, 4)))
    zero = values |> Enum.find(&(len(&1) == 6 && contains_exactly?(seven, &1, 3) && &1 != nine))
    six = values |> Enum.find(&(len(&1) == 6 && &1 != nine && &1 != zero))
    five = values |> Enum.find(&(len(&1) == 5 && contains_exactly?(six, &1, 5)))
    three = values |> Enum.find(&(len(&1) == 5 && contains_exactly?(four, &1, 3) && &1 != five))
    two = values |> Enum.find(&(len(&1) == 5 && &1 != five && &1 != three))

    keys
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(0, fn k, acc ->
      cond do
        contains_all_graphemes?(k, zero) -> appnd_n(acc, 0)
        contains_all_graphemes?(k, one) -> appnd_n(acc, 1)
        contains_all_graphemes?(k, two) -> appnd_n(acc, 2)
        contains_all_graphemes?(k, three) -> appnd_n(acc, 3)
        contains_all_graphemes?(k, four) -> appnd_n(acc, 4)
        contains_all_graphemes?(k, five) -> appnd_n(acc, 5)
        contains_all_graphemes?(k, six) -> appnd_n(acc, 6)
        contains_all_graphemes?(k, seven) -> appnd_n(acc, 7)
        contains_all_graphemes?(k, eight) -> appnd_n(acc, 8)
        contains_all_graphemes?(k, nine) -> appnd_n(acc, 9)
        true -> IO.warn("ERROR: #{k}")
      end
    end)
  end

  def contains_all_graphemes?(s, l) do
    String.graphemes(l)
    |> Enum.reduce(true, fn g, acc ->
      acc && Enum.any?(String.graphemes(s), &(&1 == g)) && len(s) == len(l)
    end)
  end

  defp contains_exactly?(s1, s2, amount) do
    String.graphemes(s1)
    |> Enum.reduce(0, fn g, acc ->
      if String.contains?(s2, to_string(g)),
        do: acc + 1,
        else: acc
    end) == amount
  end
end
