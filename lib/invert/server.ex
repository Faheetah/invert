defmodule Invert.Server do
  use GenServer

  require Logger

  alias Invert.Cache

  def start_link(tables) do
    GenServer.start_link(
      __MODULE__,
      [
        {:tables, tables},
        {:log_limit, 1_000_000}
      ],
      name: __MODULE__
    )
  end

  def init(args) do
    Logger.debug("Search core started")
    {:ok, args}
  end

  ## GenServer functions

  def handle_call({:get_tables}, _from, state) do
    {:reply, Keyword.get(state, :tables), state}
  end

  def handle_call({:get, table, item}, _from, state) do
    {duration, results} =
      :timer.tc(fn ->
        items = split_terms(item)

        found =
          items
          |> Enum.flat_map(fn item ->
            Cache.get(table, item)
          end)
          |> filter_items(items)

        {:reply, found, state}
      end)

    :telemetry.execute([:search, :query], %{total_time: duration})
    results
  end

  def handle_call({:set, table, {indexed_item, items}}, _from, state) do
    unless indexed_item == nil || indexed_item == "" do
      parse_item(indexed_item)
      |> Enum.each(fn item ->
        term =
          item
          |> String.downcase()
          |> Inflex.singularize()

        Cache.insert(table, {term, items})
      end)
    end

    {:reply, :ok, state}
  end

  def handle_call({:delete, table, {indexed_item, items}}, _from, state) do
    unless indexed_item == nil || indexed_item == "" do
      parse_item(indexed_item)
      |> Enum.each(fn i ->
        Cache.delete(table, List.to_tuple([Inflex.singularize(String.downcase(i)) | items]))
      end)
    end

    {:reply, :ok, state}
  end

  ## Private logic

  defp split_terms(item) do
    Regex.scan(~r/[a-zA-Z]+/, item)
    |> Enum.map(fn [i] -> i end)
    |> Enum.reject(&(&1 == "" || &1 == nil))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&Inflex.singularize/1)
    |> Enum.reject(&(&1 == "" || &1 == nil))
    |> Enum.sort()
  end

  defp filter_items(results, items) do
    results
    |> Enum.dedup_by(&elem(&1, 1))
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    |> Enum.map(fn {value, keywords} ->
      diff = List.myers_difference(keywords, items)
      score = length(Keyword.get(diff, :eq, [])) - (length(Keyword.get(diff, :ins, [])) / 4)
      {value, score}
    end)
    |> Enum.sort_by(&elem(&1, 1), :desc)
  end

  defp parse_item(value) do
    Regex.scan(~r/[a-zA-Z]+/, value)
    |> Enum.map(fn [i] -> i end)
    |> Enum.reject(&(&1 == "" || &1 == nil))
    |> Enum.sort()
    |> Enum.dedup()
  end
end
