defmodule InvertTest do
  use ExUnit.Case
  doctest Invert

  setup_all do
    [
      "beef",
      "beef bar",
      "beef bar in oil",
      "bar of soap",
      "saddle soap",
      "beef jerky"
    ]
    |> Enum.with_index()
    |> Enum.each(fn {entry, index} ->
      entry
      |> String.split(" ")
      |> Enum.each(fn word ->
        Invert.set(InvertTest, :name, {word, [entry, index]})
      end)
    end)
  end

  test "finds things" do
    results =
      Invert.get(InvertTest, :name, "beef bar oil")
      |> then(fn {:ok, x} -> x end)

    assert {["beef bar in oil", _], _} = hd(results)
  end
end
