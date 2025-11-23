defmodule Aoc.Y2015.D5 do
  @contains_vowels ~r/(?=(.*[aeiou]){3}).*/
  @has_adjacent_twin ~r/.*(.)\1.*/
  @contains_no_bad_chars ~r/^(?!.*(ab|cd|pq|xy)).*$/
  @has_non_overlapping_pair ~r/.*(..).*\1.*/
  @has_non_adjacent_twin ~r/.*(.).\1.*/

  def count_nice(strings) do
    Enum.count(
      strings,
      &(&1 =~ @contains_vowels and
          &1 =~ @has_adjacent_twin and
          &1 =~ @contains_no_bad_chars)
    )
  end

  def count_nice_part2(strings) do
    Enum.count(
      strings,
      &(&1 =~ @has_non_overlapping_pair and
          &1 =~ @has_non_adjacent_twin)
    )
  end

  def parse(input), do: String.split(input)
  def part1(input), do: count_nice(input)
  def part2(input), do: count_nice_part2(input)
end
