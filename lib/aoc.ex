defmodule Aoc do
  @base_url "https://adventofcode.com"

  def lock!() do
    [y, d] = current_date!()
    lock!(y, d)
  end

  @doc """
  Dont use in loops or cocurrencty
  """
  def lock!(y, d) do
    [r1, r2] = rs = run!(y, d)

    case ask_yes_no("Locking these results
  Part 1: #{r1}
  Part 2: #{r2}
      ") do
      :no ->
        IO.puts("Do not lock")

      :yes ->
        IO.puts("Commanding lock")
        output!(y, d, rs)
    end
  end

  def test!() do
    [y, d] = current_date!()
    test!(y, d)
  end

  def test!(y, d) do
    [r1, r2] = result!(y, d)
    [p1, p2] = run!(y, d) |> Enum.map(&to_string/1)

    ("test for #{d}, #{y} " <>
       if p1 == r1 && p2 == r2 do
         "Passed"
       else
         "Failed" <>
           "\nexpected part 1: #{r1} | part 2: #{r2}"
       end <>
       "\nrecieved part 1: #{p1} | part 2: #{p2}")
    |> IO.puts()
  end

  def run!() do
    [y, d] = current_date!()
    run!(y, d)
  end

  def run!(y, d) do
    module = Module.concat(Aoc, :"Y#{y}.D#{d}")
    input = apply(module, :parse, [input!(y, d)])

    Enum.map(1..2, &Task.async(module, :"part#{&1}", [input]))
    |> Task.await_many(50_000)
  end

  def input!() do
    [y, d] = current_date!()
    input!(y, d)
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
         url: "#{@base_url}/#{y}/day/#{d}/input",
         headers: %{"Cookie" => "session=#{cookie};"},
         into: File.stream!(filepath)
       ).status != 200 do
      raise "Challenge not found for #{y}/#{d}"
    end

    IO.puts("Successfully saved to #{filepath}.")
  end

  def quest!() do
    [y, d] = current_date!()
    quest!(y, d)
  end

  def quest!(y, d) do
    url = @base_url <> "/#{y}/day/#{d}"

    case :os.type() do
      {:unix, :darwin} -> System.cmd("open", [url])
      {:unix, _} -> System.cmd("xdg-open", [url])
      {:win32, _} -> System.cmd("cmd.exe", ["/c", "start", url])
    end
  end

  def setup!(y, d) do
    File.mkdir_p("lib/#{y}")
    filepath = "lib/#{y}/#{d}.ex"
    System.put_env("AOC_CURRENT_DATE", "#{y} #{d}")

    if File.exists?(filepath) do
      IO.puts("File already exists at #{filepath}.")
    else
      File.write!(filepath, """
      defmodule Aoc.Y#{y}.D#{d} do
        def parse(input), do: input\n
        def part1(input), do: input\n
        def part2(_), do: nil
      end
      """)

      IO.puts("Successfully setup #{filepath}.")
    end
  end

  def output!(y, d, rs) do
    File.mkdir_p("result/#{y}")
    filepath = "result/#{y}/#{d}.txt"
    content = Enum.join(rs, "\n")
    File.write!(filepath, content)
  end

  defp current_date!() do
    case System.get_env("AOC_CURRENT_DATE") do
      nil ->
        raise {:error, "AOC_CURRENT_DATE environment variable not set."}

      cookie ->
        String.split(cookie)
    end
  end

  # Private function to securely retrieve the session cookie
  defp session_cookie!() do
    case System.get_env("AOC_SESSION_COOKIE") do
      nil ->
        raise {:error, "AOC_SESSION_COOKIE environment variable not set."}

      cookie ->
        cookie
    end
  end

  def session_cookie!(cookie),
    do: System.put_env("AOC_SESSION_COOKIE", cookie)

  def ask_yes_no(prompt) do
    case IO.gets(prompt <> " (y/[n]): ")
         |> String.trim()
         |> String.downcase() do
      "y" -> :yes
      _ -> :no
    end
  end

  def get_events(y) do
    File.ls!("lib/#{y}")
    |> Enum.map(&(Path.basename(&1, ".ex") |> Integer.parse()))
    |> Enum.filter(fn
      {i, ""} -> i in 1..25
      _ -> false
    end)
    |> Enum.map(&elem(&1, 0))
  end

  def read_results(y) do
    File.ls!("result/#{y}")
    |> Enum.map(&(Path.basename(&1, ".txt") |> Integer.parse()))
    |> Enum.filter(fn
      {i, ""} -> i in 1..25
      _ -> false
    end)
    |> Enum.map(fn {d, _} ->
      {d, result!(y, d)}
    end)
  end

  def result!() do
    [y, d] = current_date!()
    result!(y, d)
  end

  def result!(y, d) do
    File.read!("result/#{y}/#{d}.txt")
    |> String.split("\n", trim: true)
  end
end
