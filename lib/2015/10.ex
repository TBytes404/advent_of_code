defmodule Aoc.Y2015.D10 do
  def parse(input), do: input

  defp read_aloud(input) do
    String.graphemes(input)
    |> Enum.chunk_by(& &1)
    |> Enum.map(fn g = [h | _] ->
      (length(g) |> to_string()) <> h
    end)
    |> Enum.join()
  end

  defp looknsay(input, times) do
    Enum.reduce(1..times, input, fn _, acc ->
      read_aloud(acc)
    end)
    |> String.length()
  end

  def part1(input), do: looknsay(input, 40)
  def part2(input), do: looknsay(input, 50)
end
