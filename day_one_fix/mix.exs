defmodule DayOneApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :day_one_app,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # This is where we tell the runtime that this codebase contains an OTP application.
      mod: {DayOneApp, []},
      extra_applications: [:logger, :doma_chaperon]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # doma_chaperon version 0.3.1. A declarative load generator.
      {:doma_chaperon, "~> 0.3.2", only: [:dev], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
