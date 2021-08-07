defmodule InvertTest do
  use ExUnit.Case
  doctest Invert

  setup_all do
    [
      "beef bar",
      "beef bar in oil",
      "beef",
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

  test "finds the best match for long terms" do
    results =
      Invert.get(InvertTest, :name, "beef bar oil")
      |> then(fn {:ok, x} -> x end)

    assert {["beef bar in oil", _], _} = hd(results)
  end

  test "finds the best match for short terms" do
    results =
      Invert.get(InvertTest, :name, "beef jerky")
      |> then(fn {:ok, x} -> x end)
      |> IO.inspect

    assert {["beef jerky", _], _} = hd(results)
  end

  test "finds the best match for one term" do
    results =
      Invert.get(InvertTest, :name, "beef")
      |> then(fn {:ok, x} -> x end)

    assert {["beef", _], _} = hd(results)
  end
end
