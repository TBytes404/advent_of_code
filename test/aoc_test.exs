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
        {i, ""} when i in 1..25 -> true
        _ -> false
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sort()

    Task.async_stream(days, &[&1 | Aoc.run!(2015, &1)], timeout: 50_000)
    |> Enum.each(fn {:ok, [d, a, b]} ->
      IO.puts("day #{d}, part 1: #{a} | part 2: #{b}")
    end)
  end
end
