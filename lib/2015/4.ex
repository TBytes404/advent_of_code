defmodule Aoc.Y2015.D4 do
  def create_hash(secret) do
    :crypto.hash(:md5, secret) |> Base.encode16()
  end

  def find_answer(answer, input, pattern) do
    case create_hash(input <> Integer.to_string(answer)) do
      ^pattern <> _ -> answer
      _ -> find_answer(answer + 1, input, pattern)
    end
  end

  def parse(input), do: input
  def part1(input), do: find_answer(1, input, "00000")
  def part2(input), do: find_answer(1, input, "000000")
end
