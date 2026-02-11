defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "Advent of Code" do
    year = 2015
    IO.puts("year #{year}")
    results = Aoc.read_results(year) |> Map.new()

    Aoc.get_events(year)
    |> Task.async_stream(&{&1, Aoc.run!(year, &1)},
      timeout: 50_000,
      ordered: false,
      max_concurrency: System.schedulers_online()
    )
    |> Enum.each(fn {:ok, {d, [a, b]}} ->
      IO.puts("day #{d}, part 1: #{a} | part 2: #{b}")
      [p1, p2] = Map.fetch!(results, d)
      assert to_string(a) == p1 && to_string(b) == p2, "=#{p1} | #{p2}"
    end)
  end
end
