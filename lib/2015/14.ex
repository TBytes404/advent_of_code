defmodule Aoc.Y2015.D14 do
  @m 2503

  def parse(input),
    do:
      input
      |> String.split("\n")
      |> Map.new(&capture/1)

  defp capture(line) do
    [_, a, s, d, r] =
      ~r"(\w+) can fly (\d+) km/s for (\d+) seconds, .* (\d+) seconds."
      |> Regex.run(line)

    [s, d, r] =
      [s, d, r]
      |> Enum.map(
        &with {n, ""} <-
                Integer.parse(&1),
              do: n
      )

    {a, {s, d, r}}
  end

  def part1(input) do
    input
    |> Enum.map(fn {_, {s, d, r}} ->
      c = d + r
      f = div(@m, c)
      t = min(rem(@m, c), d)
      (f * d + t) * s
    end)
    |> Enum.max()
  end

  def part2(input) do
    0..(@m - 1)
    |> Enum.reduce(%{}, fn i, acc ->
      input
      |> Enum.reduce(acc, fn {a, {s, d, r}}, acc ->
        Map.update(acc, a, {s, 0}, fn {v, p} ->
          if rem(i, d + r) < d,
            do: {v + s, p},
            else: {v, p}
        end)
      end)
      |> count_points()
    end)
    |> Map.values()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  defp count_points(ret) do
    with {m, _} <- Map.values(ret) |> Enum.max_by(&elem(&1, 0)) do
      Map.filter(ret, fn {_, {v, _}} -> v == m end)
    end
    |> Map.keys()
    |> Enum.reduce(ret, fn k, ret ->
      Map.update!(ret, k, fn {v, p} ->
        {v, p + 1}
      end)
    end)
  end
end
