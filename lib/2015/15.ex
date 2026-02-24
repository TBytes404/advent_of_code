defmodule Aoc.Y2015.D15 do
  @total 100

  def parse(input) do
    input
    |> String.split("\n")
    |> Map.new(fn line ->
      [k, v] = String.split(line, ": ", parts: 2)

      v =
        String.split(v, ", ", parts: 5)
        |> Map.new(fn kv ->
          [k, v] = String.split(kv, " ", parts: 2)
          {v, ""} = Integer.parse(v)
          {k, v}
        end)

      {k, v}
    end)
  end

  defp distribute(1, total), do: [[total]]

  defp distribute(n, total) do
    for i <- 0..total,
        rest <- distribute(n - 1, total - i) do
      [i | rest]
    end
  end

  defp score(input) do
    input
    |> Map.values()
    |> Enum.map(&max(0, &1))
  end

  defp exec(input) do
    ks = input |> Map.keys()

    length(ks)
    |> distribute(@total)
    |> Enum.map(fn d ->
      kr = Enum.zip(ks, d) |> Map.new()

      input
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Enum.reduce(v, acc, fn {p, v}, acc ->
          Map.update(acc, p, v * kr[k], &(&1 + v * kr[k]))
        end)
      end)
    end)
  end

  def part1(input) do
    exec(input)
    |> Enum.map(fn ps ->
      Map.delete(ps, "calories")
      |> score()
      |> Enum.reduce(&Kernel.*/2)
    end)
    |> Enum.max()
  end

  def part2(input) do
    exec(input)
    |> Enum.map(&score/1)
    |> Enum.filter(fn [c | _] -> c == 500 end)
    |> Enum.map(fn m ->
      List.delete_at(m, 0)
      |> Enum.reduce(&Kernel.*/2)
    end)
    |> Enum.max()
  end
end
