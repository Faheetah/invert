defmodule Invert.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    tables =
      Application.get_env(:invert, Invert)
      |> Keyword.get(:tables)

    children = [
      {Invert.Cache, tables},
      {Invert.Server, tables},
    ]

    opts = [strategy: :one_for_one, name: Invert.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
