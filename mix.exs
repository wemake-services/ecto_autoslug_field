defmodule EctoAutoslugField.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ecto_autoslug_field,
      version: @version,
      elixir: "~> 1.2",
      deps: deps,

      # Hex
      description: description,
      package: package,

      # Test coverage:
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      # Database:
      {:ecto, ">= 0.10.0"},

      # Slugs:
      {:slugger, "~> 0.1.0"},

      # Testing:
      {:excoveralls, "~> 0.5", only: :test},
      {:credo, "~> 0.4", only: [:dev, :test]},
    ]
  end

  defp description do
    """
    Autoslug field for Ecto.
    """
  end

  defp package do
    [
      maintainers: ["Nikita Sobolev"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/sobolevn/ecto_autoslug_field",
      },
      files: ~w(mix.exs README.md lib),
    ]
  end
end
