defmodule Aoc.Y2015.D6 do
  def toggle(instructions, matrix),
    do:
      Enum.reduce(instructions, matrix, &act1/2)
      |> Enum.count(fn {_, v} -> v end)

  def act1(inst, matrix) do
    case inst do
      "turn on " <> coords -> merge(matrix, coords, true)
      "turn off " <> coords -> merge(matrix, coords, false)
      "toggle " <> coords -> merge(matrix, coords, true, &(!&1))
    end
  end

  def brighten(instructions, matrix),
    do:
      Enum.reduce(instructions, matrix, &act2/2)
      |> Map.values()
      |> Enum.sum()

  def act2(inst, matrix) do
    case inst do
      "turn on " <> coords -> merge(matrix, coords, 1, &(&1 + 1))
      "turn off " <> coords -> merge(matrix, coords, 0, &max(0, &1 - 1))
      "toggle " <> coords -> merge(matrix, coords, 2, &(&1 + 2))
    end
  end

  def keys(coords) do
    [srow, scol, erow, ecol] =
      String.split(coords, " through ")
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)

    for row <- srow..erow, col <- scol..ecol, do: {row, col}
  end

  def merge(matrix, coords, default), do: Map.merge(matrix, Map.from_keys(keys(coords), default))

  def merge(matrix, coords, default, fun),
    do: Map.merge(matrix, Map.from_keys(keys(coords), default), fn _, v, _ -> fun.(v) end)

  def parse(input), do: String.split(input, "\n")
  def part1(input), do: toggle(input, %{})
  def part2(input), do: brighten(input, %{})
end
