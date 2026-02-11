defmodule Aoc.Y2015.D9 do
  def parse(input) do
    map =
      String.split(input, "\n")
      |> Enum.reduce(%{}, &extract/2)

    permute(Map.keys(map))
    |> Enum.map(
      &(Enum.chunk_every(&1, 2, 1, :discard)
        |> Enum.map(fn [x, y] -> map[x][y] end)
        |> Enum.sum())
    )
  end

  defp extract(line, map) do
    [tup, dist] = String.split(line, " = ")
    [x, y] = String.split(tup, " to ")
    dist = String.to_integer(dist)

    map
    |> Map.update(x, %{y => dist}, &Map.put(&1, y, dist))
    |> Map.update(y, %{x => dist}, &Map.put(&1, x, dist))
  end

  defp permute([]), do: [[]]

  defp permute(terms),
    do: for(t <- terms, u <- permute(terms -- [t]), do: [t | u])

  def part1(dists), do: Enum.min(dists)
  def part2(dists), do: Enum.max(dists)
end
