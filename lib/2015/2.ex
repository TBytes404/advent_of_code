defmodule Aoc.Y2015.D2 do
  def parse_dimentions(dimentions) do
    String.split(dimentions, "x") |> Enum.map(&String.to_integer/1)
  end

  def calculate_wrapper([l, w, h]) do
    surfaces = [l * w, w * h, h * l]
    2 * Enum.sum(surfaces) + Enum.min(surfaces)
  end

  def calculate_ribbon([l, w, h]) do
    [m, n, _] = Enum.sort([l, w, h])
    l * w * h + 2 * (m + n)
  end

  def place_order(boxes, commodity) do
    String.split(boxes, "\n")
    |> Enum.map(&(parse_dimentions(&1) |> commodity.()))
    |> Enum.sum()
  end

  def aoc(input) do
    IO.puts("Required wrapping paper area: #{place_order(input, &calculate_wrapper/1)}")
    IO.puts("Required ribbon length: #{place_order(input, &calculate_ribbon/1)}")
  end
end
