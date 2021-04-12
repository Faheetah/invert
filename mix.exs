defmodule Invert.MixProject do
  use Mix.Project

  @source_url "https://github.com/faheetah/invert"
  @version "0.1.0"

  def project do
    [
      app: :invert,
      version: @version,
      elixir: "~> 1.11",
      deps: deps(),
      description: "An inverted index cache built on top of ETS",
      package: package(),
      name: "Invert",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Invert.Application, []}
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 0.4"},
      {:inflex, "~> 2.1.0"},
      {:ex_doc, "0.24.2", only: :docs},
      {:exprof, "~> 0.2.4"} #, only: :dev},
    ]
  end

  defp package do
    [
      maintainers: ["William Normand"],
      licenses: ["MIT"],
      links: %{"gitHub" => @source_url},
      files: ~w(.formatter.exs mix.exs README.md CHANGELOG.md lib)
    ]
  end

  defp docs do
    [
      main: "Invert",
      source_ref: "v#{@version}",
    ]
  end
end
