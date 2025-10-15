defmodule D3 do
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
    D3.map_houses(MapSet.new([{0, 0}]), {0, 0}, santa) |> D3.map_houses({0, 0}, robot)
  end
end

input = IO.read(:eof) |> String.trim()
IO.puts("Santa visited houses: #{D3.map_houses(input) |> Enum.count()}")
IO.puts("Santa & Robo visited houses: #{D3.double_map_house(input) |> Enum.count()}")
