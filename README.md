# Invert

A simple inverted index written in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `invert` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:invert, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/invert](https://hexdocs.pm/invert).

## Configuration

Configure tables to cache

```
config :invert, :tables,
  [
    {TestInvert, :name, [:name, :id]}
  ]
```
