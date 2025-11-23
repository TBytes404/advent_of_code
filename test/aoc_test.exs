defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "runs the world" do
    Enum.each(1..6, &Aoc.run!(2015, &1))
  end
end
