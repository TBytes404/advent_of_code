defmodule Aoc.Y2015.D1 do
  def count_floors(floor, instructions) do
    case instructions do
      "(" <> rest -> count_floors(floor + 1, rest)
      ")" <> rest -> count_floors(floor - 1, rest)
      "" -> floor
    end
  end

  def find_basement(position, floor, instructions) do
    if floor == -1 do
      position
    else
      case instructions do
        "(" <> rest -> find_basement(position + 1, floor + 1, rest)
        ")" <> rest -> find_basement(position + 1, floor - 1, rest)
        "" -> 0
      end
    end
  end

  def parse(input), do: input
  def part1(input), do: count_floors(0, input)
  def part2(input), do: find_basement(0, 0, input)
end
