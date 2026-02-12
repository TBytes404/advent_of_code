defmodule Aoc.Y2015.D11 do
  def parse(input) do
    to_charlist(input)
    |> Enum.reverse()
    |> next_char()
  end

  defp validate(input) do
    has_no_invalid(input) &&
      has_two_pairs(input) &&
      has_straight(input)
  end

  defp has_no_invalid(input) do
    input |> Enum.all?(&(&1 not in [?i, ?o, ?l]))
  end

  defp has_two_pairs(input) do
    input
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> a == b end)
    |> Enum.map(&hd/1)
    |> Enum.uniq()
    |> length() > 1
  end

  defp has_straight(input) do
    Enum.chunk_every(input, 3, 1, :discard)
    |> Enum.any?(fn [x, y, z] ->
      x == y + 1 && y == z + 1
    end)
  end

  defp next_char([]), do: []

  defp next_char([c | rst]) do
    cond do
      c in ?a..?y -> [c + 1 | rst]
      c == ?z -> [?a | next_char(rst)]
    end
  end

  defp generate(input) do
    next = next_char(input)

    if validate(next),
      do: next,
      else: generate(next)
  end

  defp format(pass), do: pass |> Enum.reverse() |> to_string()

  def part1(input), do: input |> generate() |> format()
  def part2(input), do: input |> generate() |> generate() |> format()
end
