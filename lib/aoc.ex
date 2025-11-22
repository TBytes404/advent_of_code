defmodule Aoc do
  def run!(y, d) do
    input = input!(y, d) |> String.trim()
    module = Module.concat(Aoc, :"Y#{y}.D#{d}")
    apply(module, :aoc, [input])
  end

  @doc """
  Reads input for a specific year/day combo (e.g., "2023/1") from a local file.
  Fetches the input from Advent of Code if the file doesn't exist.
  """
  def input!(y, d) do
    File.mkdir_p("input/#{y}")
    filepath = "input/#{y}/#{d}.txt"

    case File.read(filepath) do
      {:ok, content} ->
        content

      {:error, reason} ->
        IO.puts("File not found or unreadable: #{reason}. Attempting to fetch...")

        fetch!(y, d, File.stream!(filepath))
        IO.puts("Successfully saved to #{filepath}.")

        input!(y, d)
    end
  end

  @doc """
  Fetches the input from the Advent of Code website using the session cookie.
  """
  def fetch!(y, d, file) do
    cookie = session_cookie!()
    url = "https://adventofcode.com/#{y}/day/#{d}/input"

    IO.puts("Fetching from #{url}...")

    Req.get!(
      url: url,
      headers: %{"Cookie" => "session=#{cookie};"},
      into: file
    )
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
