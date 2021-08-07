import Config

config :invert, Invert,
  tables: [
    {InvertTest, :name, [:name, :id]},
  ]
