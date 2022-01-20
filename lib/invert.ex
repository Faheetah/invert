defmodule Invert do
  @moduledoc """
  Documentation for `Invert`.
  """

  require Logger

  alias Invert.Cache
  alias Invert.Helpers

  ## Public API

  # [{InvertTest, :name, [:name, :id]}]
  def get_tables() do
    GenServer.call(Invert.Server, {:get_tables}, 500)
  end

  # Invert.delete(InvertTest, :name, {"invert", ["invert", 1]})
  def delete(module, name, item) do
    table = Helpers.atom_from_module(module, name)
    GenServer.call(Invert.Server, {:delete, table, item}, 500)
  end

  # Invert.set(InvertTest, :name, {"invert", ["invert", 1]})
  def set(module, name, item) do
    table = Helpers.atom_from_module(module, name)
    GenServer.call(Invert.Server, {:set, table, item}, 500)
  end

  # Invert.get(InvertTest, :name, "invert")
  # @todo this needs to not swallow GenServer.call
  def get(module, name, item) do
    call =
      try do
        table = Helpers.atom_from_module(module, name)
        GenServer.call(Invert.Server, {:get, table, item}, 25000)
      rescue
        ArgumentError ->
          atom = Helpers.parse_atom_from_module(module, name)

          Logger.error("
            Table #{atom} does not exist in ETS.
            Is #{module}/#{name} configured in the cache?
            Verify the Invert.Hydrator application is configured with cache_tables.
          ")

          []
      end

    case call do
      [] -> {:error, :not_found}
      results -> {:ok, results}
    end
  end

  def get_count(module, field, _) do
    table = Helpers.new_atom_from_module(module, field)
    total = Cache.size(table)
    :telemetry.execute([:search, :items, table], %{total: total})
  end
end
