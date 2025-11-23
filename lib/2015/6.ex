defmodule Aoc.Y2015.D6 do
  def aoc(input) do
    instructions = String.split(input, "\n")
    IO.puts("lights are lit: #{part1(instructions, %{})}")
    IO.puts("total brightness is: #{part2(instructions, %{})}")
  end

  def part1(instructions, matrix),
    do:
      Enum.reduce(instructions, matrix, &act1/2)
      |> Map.filter(fn {_, v} -> v end)
      |> Enum.count()

  def act1(inst, matrix) do
    case inst do
      "turn on " <> coords -> merge(matrix, coords, true)
      "turn off " <> coords -> merge(matrix, coords, false)
      "toggle " <> coords -> merge(matrix, coords, true, &(!&1))
    end
  end

  def part2(instructions, matrix),
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

  def parse(coords) do
    [srow, scol, erow, ecol] =
      String.split(coords, " through ")
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)

    for row <- srow..erow, col <- scol..ecol, do: {row, col}
  end

  def merge(matrix, coords, default), do: Map.merge(matrix, Map.from_keys(parse(coords), default))

  def merge(matrix, coords, default, fun),
    do: Map.merge(matrix, Map.from_keys(parse(coords), default), fn _, v, _ -> fun.(v) end)
end
