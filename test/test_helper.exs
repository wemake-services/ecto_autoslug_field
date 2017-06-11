# Slug fields:

defmodule EctoAutoslugField.Test.TestSchema.SimpleSlug do
  use EctoAutoslugField.Slug, from: :name, to: :simple_slug
end

defmodule EctoAutoslugField.Test.TestSchema.MultipleSourcesSlug do
  use EctoAutoslugField.Slug, from: [:name, :company],
    to: :multiple_sources_slug
end

defmodule EctoAutoslugField.Test.TestSchema.ComplexSlug do
  use EctoAutoslugField.Slug, to: :complex_slug

  def get_sources(_changeset, _opts), do: [:name, :company]

  def build_slug(sources) do
    sources
    |> super
    |> String.replace("-", "+")
  end
end

defmodule EctoAutoslugField.Test.TestSchema.ConditionalSlug do
  use EctoAutoslugField.Slug, to: :conditional_slug

  def get_sources(changeset, _opts) do
    if Map.has_key?(changeset.changes(), :company) do
      [:name, :company]
    else
      [:name]
    end
  end
end

defmodule EctoAutoslugField.Test.TestSchema.AlwaysChangeSlug do
  use EctoAutoslugField.Slug, from: :name, to: :changing_slug,
    always_change: true
end


# Test schema:

defmodule EctoAutoslugField.Test.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias EctoAutoslugField.Test.TestSchema.SimpleSlug
  alias EctoAutoslugField.Test.TestSchema.MultipleSourcesSlug
  alias EctoAutoslugField.Test.TestSchema.ComplexSlug
  alias EctoAutoslugField.Test.TestSchema.ConditionalSlug
  alias EctoAutoslugField.Test.TestSchema.AlwaysChangeSlug

  schema "user" do
    field :name, :string
    field :company, :string

    field :simple_slug, SimpleSlug.Type
    field :multiple_sources_slug, MultipleSourcesSlug.Type
    field :complex_slug, ComplexSlug.Type
    field :conditional_slug, ConditionalSlug.Type
    field :changing_slug, AlwaysChangeSlug.Type
  end

  def changeset(model, params \\ :invalid) do
    all_fields = [
      :name,
      :company,
      :simple_slug,
      :multiple_sources_slug,
      :complex_slug,
      :conditional_slug,
      :changing_slug,
    ]

    model
    |> cast(params, all_fields)
    |> validate_required([:name])
    |> SimpleSlug.maybe_generate_slug
    |> MultipleSourcesSlug.maybe_generate_slug
    |> ComplexSlug.maybe_generate_slug
    |> ConditionalSlug.maybe_generate_slug
    |> AlwaysChangeSlug.maybe_generate_slug
  end
end


# Run tests:
ExUnit.start()
