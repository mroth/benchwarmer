defmodule Benchwarmer.Mixfile do
  use Mix.Project

  def project do
    [
      app:          :benchwarmer,
      version:      "0.0.1",
      elixir:       "~> 0.14.3",
      deps:         deps,
      name:         "Benchwarmer",
      source_url:   "https://github.com/mroth/benchwarmer",
      description:  description,
      package:      package
    ]
  end

  defp description do
    """
    Benchwarmer is an Elixir micro-benchmarking utility that runs a function (or
    list of functions) repeatedly against a dataset for a period of time, and
    then reports on the average time each operation took to complete, allowing
    for easy comparison.
    """
  end

  defp package do
    [
      contributors: [ "Matthew Rothenberg <mroth@mroth.info>" ],
      licenses:     [ "WTFPL" ],
      links:        %{
                       "GitHub" => "https://github.com/mroth/benchwarmer",
                       "Docs"   => "https://mroth.github.io/benchwarmer/"
                    }
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ex_doc,  github: "elixir-lang/ex_doc", only: :dev},
      {:earmark, github: "pragdave/earmark",   only: :dev}
    ]
  end
end
