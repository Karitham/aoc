defmodule Day03 do
  def find_closest_prefix_co2(each) do
    find_closest_prefix_co2(each, "", 0)
  end

  defp find_closest_prefix_co2(each, pref, i) do
    pref =
      pref <>
        (each
         |> Enum.map(&String.graphemes/1)
         |> Enum.zip()
         |> Enum.reduce([], &reduce_p2_co2cr/2)
         |> Enum.at(i))

    each = Enum.filter(each, fn s -> String.starts_with?(s, pref) end)

    case length(each) do
      1 -> hd(each)
      0 -> raise "wtf the prefix is #{pref} but we're at iter #{i}"
      _ -> find_closest_prefix_co2(each, pref, i + 1)
    end
  end

  defp reduce_p2_co2cr(each, acc) do
    f = Enum.frequencies(Tuple.to_list(each))

    cond do
      f["0"] > f["1"] -> acc ++ ["1"]
      f["0"] < f["1"] -> acc ++ ["0"]
      f["0"] == f["1"] -> acc ++ ["0"]
    end
  end

  def find_closest_prefix_ogr(each) do
    find_closest_prefix_ogr(each, "", 0)
  end

  defp find_closest_prefix_ogr(each, pref, i) do
    pref =
      pref <>
        (each
         |> Enum.map(&String.graphemes/1)
         |> Enum.zip()
         |> Enum.reduce([], &reduce_p2_ogr/2)
         |> Enum.at(i))

    each = Enum.filter(each, fn s -> String.starts_with?(s, pref) end)

    case length(each) do
      1 -> hd(each)
      0 -> raise "wtf the prefix is #{pref} but we're at iter #{i}"
      _ -> find_closest_prefix_ogr(each, pref, i + 1)
    end
  end

  defp reduce_p2_ogr(each, acc) do
    f = Enum.frequencies(Tuple.to_list(each))

    cond do
      f["0"] > f["1"] -> acc ++ ["0"]
      f["0"] < f["1"] -> acc ++ ["1"]
      f["0"] == f["1"] -> acc ++ ["1"]
    end
  end
end
