defmodule Aoc.Y2015.D13 do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&catch_entry/1)
  end

  defp catch_entry(line) do
    [_, a, s, n, b] =
      ~r"(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\."
      |> Regex.run(line)

    {d, ""} = Integer.parse(n)
    c = if(s == "lose", do: -1, else: 1) * d
    {a, b, c}
  end

  defp capture(input) do
    input
    |> Enum.group_by(
      fn {a, _, _} -> a end,
      fn {_, b, c} -> {b, c} end
    )
    |> Map.new(fn {k, v} ->
      {k, Map.new(v)}
    end)
  end

  def part1(input) do
    capture(input)
    |> do_job
  end

  def do_job(map) do
    Map.keys(map)
    |> permute()
    |> Enum.map(&calculate(&1, map))
    |> Enum.max()
  end

  defp calculate(arr, input) do
    [List.last(arr) | arr]
    |> Enum.chunk_every(3, 1, Stream.cycle(arr))
    |> Enum.map(fn [l, a, r] ->
      input[a][l] + input[a][r]
    end)
    |> Enum.sum()
  end

  defp permute([]), do: [[]]

  defp permute(terms),
    do: for(t <- terms, u <- permute(terms -- [t]), do: [t | u])

  def part2(input) do
    names =
      input
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()

    (Enum.flat_map(names, fn g ->
       [{"Me", g, 0}, {g, "Me", 0}]
     end) ++ input)
    |> capture()
    |> do_job()
  end
end
