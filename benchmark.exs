words = File.read!("test_data_words.txt")
|> String.split("\n")

IO.puts "Hydrating"

File.read!("test_data.txt")
|> String.split("\n")
|> Enum.with_index()
|> Enum.each(fn {entry, index} ->
  entry
  |> String.split(" ")
  |> Enum.each(fn word ->
    Invert.set(InvertTest, :name, {word, [entry, index]})
  end)
end)

IO.puts "\nHydrate complete"

benchmarks = %{
  "single word" => fn -> Invert.get(InvertTest, :name, hd(words)) end,
  "two words" => fn -> Invert.get(InvertTest, :name, Enum.join(Enum.take(words, 2), " ")) end,
  "three words" => fn -> Invert.get(InvertTest, :name, Enum.join(Enum.take(words, 3), " ")) end,
  "four words" => fn -> Invert.get(InvertTest, :name, Enum.join(Enum.take(words, 4), " ")) end,
  "five words" => fn -> Invert.get(InvertTest, :name, Enum.join(Enum.take(words, 5), " ")) end,
  "six words" => fn -> Invert.get(InvertTest, :name, Enum.join(Enum.take(words, 6), " ")) end,
}

Benchee.run(benchmarks)
