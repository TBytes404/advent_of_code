defmodule D4 do
  def create_hash(secret) do
    :crypto.hash(:md5, secret) |> Base.encode16()
  end

  def find_answer(answer, input, pattern) do
    case create_hash(input <> Integer.to_string(answer)) do
      ^pattern <> _ -> answer
      _ -> find_answer(answer + 1, input, pattern)
    end
  end
end

input = IO.read(:eof) |> String.trim()

answers = [
  Task.async(fn -> IO.puts("000_00 answer is: #{D4.find_answer(1, input, "00000")}") end),
  Task.async(fn -> IO.puts("000_000 Zeros answer is: #{D4.find_answer(1, input, "000000")}") end)
]

Task.await_many(answers, 10_000)
