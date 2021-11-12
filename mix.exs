defmodule Invert.MixProject do
  use Mix.Project

  @source_url "https://github.com/faheetah/invert"
  @version "0.3.0"

  def project do
    [
      app: :invert,
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(:dev), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:telemetry, "~> 1.0.0"},
      {:inflex, "~> 2.1.0"},
      {:ex_doc, "0.24.2", only: :docs},
      {:exprof, "~> 0.2.4", only: :dev},
      {:benchee, "~> 1.0.0", runtime: false, only: :dev},
      {:mix_test_watch, "~> 1.0", runtime: false, only: :dev},
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
