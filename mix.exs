defmodule Unocss.MixProject do
  use Mix.Project

  @version "0.61.5"
  @source_url "https://github.com/ex_unocss"

  def project do
    [
      app: :unocss,
      version: @version,
      elixir: "~> 1.11",
      deps: deps(),
      description: "Mix tasks for installing and invoking unocss",
      package: [
        links: %{
          "GitHub" => @source_url,
          "unocss" => "https://unocss.dev"
        },
        licenses: ["MIT"]
      ],
      docs: [
        main: "Unocss",
        source_url: @source_url,
        source_ref: "v#{@version}",
        extras: ["CHANGELOG.md"]
      ],
      aliases: [test: ["unocss.install --if-missing", "test"]]
    ]
  end

  def application do
    [
      extra_applications: [:logger, inets: :optional, ssl: :optional],
      mod: {Unocss, []},
      env: [default: []]
    ]
  end

  defp deps do
    [
      {:castore, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: [:docs, :dev]}
    ]
  end
end
