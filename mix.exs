defmodule EctoAutoslugField.Mixfile do
  use Mix.Project

  @source_url "https://github.com/sobolevn/ecto_autoslug_field"
  @version "3.1.0"

  def project do
    [
      app: :ecto_autoslug_field,
      version: @version,
      elixir: "~> 1.13",
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,

      # Hex:
      docs: docs(),
      package: package(),

      # Test coverage:
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer:
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:ecto]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ecto, ">= 3.7.0"},

      # Slugs:
      {:slugify, "~> 1.3"},

      # Testing:
      {:excoveralls, "~> 0.17", only: :test},
      {:castore, "~> 1.0", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},

      # Documentation:
      {:ex_doc, ">= 0.30.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Autoslug field for Ecto.",
      maintainers: ["Nikita Sobolev"],
      licenses: ["MIT"],
      files: ~w(mix.exs README.md lib),
      links: %{
        "Changelog" => "https://hexdocs.pm/ecto_autoslug_field/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end
end
