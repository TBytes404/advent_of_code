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

  def aoc(input) do
    IO.puts("Destination floor: #{count_floors(0, input)}")
    IO.puts("First instruction that leads to basement: #{find_basement(0, 0, input)}")
  end
end
