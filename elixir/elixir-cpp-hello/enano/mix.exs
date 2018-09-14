defmodule Enano.MixProject do
  use Mix.Project

  def project do
    [
      app: :enano,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:enm, github: "basho/enm"},
      {:msgpax, "~> 0.7"}
    ]
  end
end
