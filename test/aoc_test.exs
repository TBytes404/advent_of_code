defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs the world" do
    year = 2015
    IO.puts("year #{year}")

    days =
      File.ls!("lib/#{year}")
      |> Enum.map(&(Path.basename(&1, ".ex") |> Integer.parse()))
      |> Enum.filter(fn
        {i, ""} -> i in 1..25
        _ -> false
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sort()

    results =
      File.read!("result/2015.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)

    Task.async_stream(days, &[&1 | Aoc.run!(2015, &1)], timeout: 50_000)
    |> Enum.each(fn {:ok, [d, a, b]} ->
      IO.puts("day #{d}, part 1: #{a} | part 2: #{b}")
      [p1, p2] = Enum.at(results, d - 1)
      assert to_string(a) == p1 && to_string(b) == p2, "=#{p1} | #{p2}"
    end)
  end
end
