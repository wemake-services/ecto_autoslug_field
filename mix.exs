defmodule EctoAutoslugField.Mixfile do
  use Mix.Project

  @version "0.5.1"
  @url "https://github.com/sobolevn/ecto_autoslug_field"

  def project do
    [app: :ecto_autoslug_field,
     version: @version,
     elixir: "~> 1.4",
     deps: deps(),

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     # Hex:
     docs: docs(),
     description: description(),
     package: package(),
     source_url: @url,
     homepage_url: @url,

     # Test coverage:
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test,
     ],

     # Dialyzer:
     dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:ecto]]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ecto, ">= 2.1.0"},

     # Slugs:
     {:slugger, ">= 0.2.0"},

     # Testing:
     {:excoveralls, "~> 0.5", only: :test},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
     {:dialyxir, "~> 0.5", only: :dev, runtime: false},

     # Documentation:
     {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
  end

  defp description do
    "Autoslug field for Ecto."
  end

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end

  defp package do
    [maintainers: ["Nikita Sobolev"],
     licenses: ["MIT"],
     links: %{"GitHub" => @url},
     files: ~w(mix.exs README.md lib)]
  end
end
