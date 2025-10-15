defmodule D2 do
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
    |> Enum.map(fn dim -> dim |> D2.parse_dimentions() |> commodity.() end)
    |> Enum.sum()
  end
end

input = IO.read(:eof) |> String.trim()
IO.puts("Required wrapping paper area: #{D2.place_order(input, &D2.calculate_wrapper/1)}")
IO.puts("Required ribbon length: #{D2.place_order(input, &D2.calculate_ribbon/1)}")
