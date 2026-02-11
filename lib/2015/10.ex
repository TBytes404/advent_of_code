defmodule Aoc.Y2015.D10 do
  def parse(input), do: to_charlist(input)

  defp read_aloud(input) do
    Enum.chunk_by(input, & &1)
    |> Enum.flat_map(fn g = [h | _] ->
      length(g)
      |> to_charlist()
      |> Kernel.++([h])
    end)
  end

  defp looknsay(input, times) do
    Enum.reduce(1..times, input, fn _, acc ->
      read_aloud(acc)
    end)
    |> length()
  end

  def part1(input), do: looknsay(input, 40)
  def part2(input), do: looknsay(input, 50)
end
