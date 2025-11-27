defmodule Aoc do
  def run!(y, d) do
    module = Module.concat(Aoc, :"Y#{y}.D#{d}")
    input = apply(module, :parse, [input!(y, d)])

    Enum.map(1..2, &Task.async(module, :"part#{&1}", [input]))
    |> Task.await_many(50_000)
  end

  @doc """
  Reads input for a specific year/day combo (e.g., "2023/1") from a local file.
  Fetches the input from Advent of Code if the file doesn't exist.
  """
  def input!(y, d) do
    filepath = "input/#{y}/#{d}.txt"

    case File.read(filepath) do
      {:ok, content} ->
        content |> String.trim()

      {:error, reason} ->
        IO.puts("File not found or unreadable: #{reason}.")
        fetch!(y, d, filepath)
        input!(y, d)
    end
  end

  @doc """
  Fetches the input from the Advent of Code website using the session cookie.
  """
  def fetch!(y, d, filepath) do
    File.mkdir_p("input/#{y}")
    cookie = session_cookie!()
    IO.puts("Attempting to fetch challenge #{y}/#{d}...")

    if Req.get!(
         url: "https://adventofcode.com/#{y}/day/#{d}/input",
         headers: %{"Cookie" => "session=#{cookie};"},
         into: File.stream!(filepath)
       ).status != 200 do
      raise "Challenge not found for #{y}/#{d}"
    end

    IO.puts("Successfully saved to #{filepath}.")
  end

  def setup!(y, d) do
    File.mkdir_p("lib/#{y}")
    filepath = "lib/#{y}/#{d}.ex"

    File.write!(filepath, """
    defmodule Aoc.Y#{y}.D#{d} do
      def parse(input), do: input
      def part1(input), do: input
      def part2(input), do: input
    end
    """)

    IO.puts("Successfully setup #{filepath}.")
  end

  # Private function to securely retrieve the session cookie
  defp session_cookie!() do
    case System.get_env("AOC_SESSION_COOKIE") do
      nil ->
        raise {:error, "AOC_SESSION_COOKIE environment variable not set. Cannot fetch input."}

      cookie ->
        cookie
    end
  end
end
