defmodule Aoc.Y2015.D16 do
  @letter %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

  def parse(input) do
    input
    |> String.split("\n")
    |> Map.new(fn "Sue " <> line ->
      with [sue, clues] <- String.split(line, ": ", parts: 2) do
        {String.to_integer(sue),
         String.split(clues, ", ")
         |> Map.new(
           &with [k, v] <- String.split(&1, ": ", parts: 2) do
             {k, String.to_integer(v)}
           end
         )}
      end
    end)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Enum.reduce(v, acc, fn {p, v}, acc ->
        Map.update(acc, p, %{v => [k]}, fn kv ->
          Map.update(kv, v, [k], &[k | &1])
        end)
      end)
    end)
  end

  defp score(output) do
    output
    |> Enum.frequencies()
    |> Enum.max(fn {_, a}, {_, b} -> a >= b end)
    |> elem(0)
  end

  def part1(input) do
    Enum.flat_map(@letter, fn {k, v} ->
      input[k][v]
    end)
    |> score()
  end

  def part2(input) do
    Enum.flat_map(@letter, fn {k, v} ->
      cond do
        Enum.member?(["cats", "trees"], k) ->
          Enum.filter(input[k], fn {k, _} -> k > v end)
          |> Enum.flat_map(fn {_, vs} -> vs end)

        Enum.member?(["pomeranians", "goldfish"], k) ->
          Enum.filter(input[k], fn {k, _} -> k < v end)
          |> Enum.flat_map(fn {_, vs} -> vs end)

        true ->
          input[k][v]
      end
    end)
    |> score()
  end
end
