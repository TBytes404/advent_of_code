defmodule Aoc.Y2015.D12 do
  def parse(input), do: input

  def part1(input) do
    ~r"-?\d+"
    |> Regex.scan(input)
    |> Enum.flat_map(& &1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {d, ""} -> d end)
    |> Enum.sum()
  end

  def part2(input) do
    with {:ok, doc} <- JSON.decode(input) do
      remove_red(doc)
      |> List.flatten()
      |> Enum.sum()
    end
  end

  defp remove_red(doc) when is_map(doc) do
    if Enum.member?(Map.values(doc), "red") do
      0
    else
      Enum.map(doc, fn {_k, v} -> remove_red(v) end)
    end
  end

  defp remove_red(doc) when is_list(doc) do
    Enum.map(doc, fn v -> remove_red(v) end)
  end

  defp remove_red(doc) when is_integer(doc), do: doc
  defp remove_red(_), do: 0
end
