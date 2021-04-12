defmodule Invert.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Invert.Cache, Application.get_env(:invert, :tables)},
      {Invert.Server, Application.get_env(:invert, :tables)},
    ]

    opts = [strategy: :one_for_one, name: Invert.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
