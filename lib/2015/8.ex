defmodule Aoc.Y2015.D8 do
  def parse(input), do: String.split(input, "\n")
  def part1(input), do: Enum.sum_by(input, fn s -> String.length(s) - decode_length(s, 0) end)
  def part2(input), do: Enum.sum_by(input, fn s -> encode_length(s, 0) end)

  def decode_length(str, len) do
    case str do
      "\\x" <> <<_::binary-size(2)>> <> rest -> decode_length(rest, len + 1)
      "\\" <> <<_::binary-size(1)>> <> rest -> decode_length(rest, len + 1)
      "\"" <> rest -> decode_length(rest, len)
      <<_::binary-size(1)>> <> rest -> decode_length(rest, len + 1)
      "" -> len
    end
  end

  def encode_length(str, len) do
    case str do
      "\\x" <> <<_::binary-size(2)>> <> rest -> encode_length(rest, len + 1)
      "\\" <> <<_::binary-size(1)>> <> rest -> encode_length(rest, len + 2)
      "\"" <> rest -> encode_length(rest, len + 1)
      <<_::binary-size(1)>> <> rest -> encode_length(rest, len)
      "" -> len + 2
    end
  end
end
