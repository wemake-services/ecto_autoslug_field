defmodule EctoAutoslugField.Mixfile do
  use Mix.Project

  @source_url "https://github.com/sobolevn/ecto_autoslug_field"
  @version "3.0.0"

  def project do
    [
      app: :ecto_autoslug_field,
      version: @version,
      elixir: "~> 1.10",
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
      dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:ecto]]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ecto, ">= 3.7.0"},

      # Slugs:
      {:slugger, ">= 0.3.0"},

      # Testing:
      {:excoveralls, "~> 0.14", only: :test},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},

      # Documentation:
      {:ex_doc, ">= 0.23.0", only: :dev, runtime: false}
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
