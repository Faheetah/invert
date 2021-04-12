defmodule Mix.Tasks.Invert.GenerateWords do
  use Mix.Task

  @words 100
  @max_words 5

  def run([num_words]) do
    File.write("test_data.txt",
      load_words()
      |> parse_words(String.to_integer(num_words))
      |> Enum.sort
      |> Enum.dedup
      |> Enum.join("\n")
    )
  end

  def load_words() do
    case File.read("/usr/share/dict/words") do
      {:ok, f} ->
        word_pool =
          f
          |> String.split("\n")
          |> Enum.take_random(@words)
        word_pool = ["invert"] ++ word_pool
        File.write("test_data_words.txt", Enum.join(word_pool, "\n"))
        List.to_tuple(word_pool)
      {:error, e} ->
        IO.puts "Could not load word dictionary /usr/share/dict/words: #{e}"
        []
    end
  end

  def parse_words(words, num_words) do
    1..num_words
    |> Enum.map(fn _ ->
      term =
        1..Enum.random(1..@max_words)
        |> Enum.map(fn _ ->
          elem(words, Enum.random(0..@words - 1))
        end)
        |> Enum.join(" ")

      term
    end)
  end
end
