defmodule InvertTest.WordLoader do
  @chunk 10000

  def load() do
    case File.read("test_data.txt") do
      {:ok, f} ->
        if Mix.env() == :dev do
          IO.puts "Loading test data"
        end

        :ok = f
        |> String.split("\n")
        |> Enum.with_index
        |> Enum.chunk_every(@chunk)
        |> Enum.with_index
        |> Enum.each(fn {items, index} ->
          if Mix.env() == :dev do
            IO.puts "Loaded #{(index + 1) * @chunk}"
          end

          Enum.each(items, fn {word, index} ->
            Invert.set(InvertTest, :name, {word, [word, index]})
          end)
        end)
      {:error, _} ->
        IO.puts "Could not load sample data, generate with 'mix invert.generate_words 1000000'"
        []
    end
  end

  def get_word_list() do
    File.read!("test_data_words.txt")
    |> String.split("\n")
  end
end
