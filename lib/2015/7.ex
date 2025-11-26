defmodule Aoc.Y2015.D7 do
  import Bitwise

  def parse(input) do
    String.split(input, "\n")
    |> Map.new(fn line ->
      [v, k] = String.split(line, " -> ")
      {k, String.split(v)}
    end)
  end

  def part1(input), do: eval(["a"], input)

  def part2(input) do
    a = eval(["a"], input)
    input = Map.replace(input, "b", [to_string(a)])
    clear()
    eval(["a"], input)
  end

  def eval([a, cmd, b], dict) do
    (case cmd do
       "AND" -> &band/2
       "OR" -> &bor/2
       "LSHIFT" -> &bsl/2
       "RSHIFT" -> &bsr/2
     end).(eval([a], dict), eval([b], dict))
  end

  def eval(["NOT", v], dict), do: eval([v], dict) |> bnot()

  def eval([v], dict) do
    case Integer.parse(v) do
      {i, ""} -> i
      _ -> memo(v, fn -> Map.get(dict, v) |> eval(dict) end)
    end
  end

  defp memo(v, fun) do
    case Process.get({:memo, v}) do
      nil ->
        val = fun.()
        Process.put({:memo, v}, val)
        val

      i ->
        i
    end
  end

  defp clear, do: for(k = {:memo, _} <- Process.get_keys(), do: Process.delete(k))
end
