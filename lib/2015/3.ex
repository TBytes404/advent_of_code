defmodule Aoc.Y2015.D3 do
  def map_houses(map, position, directions) do
    if directions == "" do
      map
    else
      position =
        case directions do
          "<" <> _ -> put_elem(position, 0, elem(position, 0) - 1)
          ">" <> _ -> put_elem(position, 0, elem(position, 0) + 1)
          "^" <> _ -> put_elem(position, 1, elem(position, 1) - 1)
          "v" <> _ -> put_elem(position, 1, elem(position, 1) + 1)
        end

      map_houses(
        MapSet.put(map, position),
        position,
        String.slice(directions, 1, String.length(directions))
      )
    end
  end

  def map_houses(input) do
    map_houses(MapSet.new([{0, 0}]), {0, 0}, input)
  end

  def double_map_house(input) do
    santa = String.to_charlist(input) |> Enum.take_every(2) |> to_string()
    robot = String.to_charlist(input) |> Enum.drop_every(2) |> to_string()
    map_houses(santa) |> map_houses({0, 0}, robot)
  end

  def parse(input), do: input
  def part1(input), do: map_houses(input) |> Enum.count()
  def part2(input), do: double_map_house(input) |> Enum.count()
end
