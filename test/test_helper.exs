# Slug fields:

defmodule EctoAutoslugField.Test.TestSchema.SimpleSlug do
  use EctoAutoslugField.Slug, from: :name, to: :simple_slug
end

defmodule EctoAutoslugField.Test.TestSchema.SimpleSlugForce do
  use EctoAutoslugField.Slug, from: :name, to: :simple_slug_force
end

defmodule EctoAutoslugField.Test.TestSchema.MultipleSourcesSlug do
  use EctoAutoslugField.Slug,
    from: [:name, :company],
    to: :multiple_sources_slug
end

defmodule EctoAutoslugField.Test.TestSchema.IdFieldSlug do
  use EctoAutoslugField.Slug,
    from: [:name, :company, :link_id],
    to: :id_field_slug
end

defmodule EctoAutoslugField.Test.TestSchema.DateTimeSlug do
  use EctoAutoslugField.Slug,
    from: [
      :name,
      :company,
      :date_field,
      :time_field,
      :naive_datetime_field,
      :utc_datetime_field
    ],
    to: :datetime_slug
end

defmodule EctoAutoslugField.Test.TestSchema.MultiTypeSlug do
  use EctoAutoslugField.Slug,
    from: [:name, :company, :float_amount, :decimal_amount, :flag],
    to: :multitype_slug
end

defmodule EctoAutoslugField.Test.TestSchema.ComplexSlug do
  use EctoAutoslugField.Slug, to: :complex_slug

  def get_sources(_changeset, _opts), do: [:name, :company]

  def build_slug(sources, changeset) do
    sources
    |> super(changeset)
    |> String.replace("-", "+")
  end
end

defmodule EctoAutoslugField.Test.TestSchema.ConditionalSlug do
  use EctoAutoslugField.Slug, to: :conditional_slug

  def get_sources(changeset, _opts) do
    if Map.has_key?(changeset.changes, :company) do
      [:name, :company]
    else
      [:name]
    end
  end
end

defmodule EctoAutoslugField.Test.TestSchema.AlwaysChangeSlug do
  use EctoAutoslugField.Slug,
    from: :name,
    to: :changing_slug,
    always_change: true
end

# Test schema:

defmodule EctoAutoslugField.Test.User do
  use Ecto.Schema

  import Ecto.Changeset

  # credo:disable-for-next-line Credo.Check.Readability.AliasOrder
  alias EctoAutoslugField.Test.TestSchema.{
    AlwaysChangeSlug,
    ConditionalSlug,
    ComplexSlug,
    DateTimeSlug,
    IdFieldSlug,
    MultiTypeSlug,
    MultipleSourcesSlug,
    SimpleSlugForce,
    SimpleSlug
  }

  schema "user" do
    field(:name, :string)
    field(:company, :string)
    field(:link_id, :integer)
    field(:float_amount, :float)
    field(:decimal_amount, :decimal)
    field(:flag, :boolean)
    field(:date_field, :date)
    field(:time_field, :time)
    field(:naive_datetime_field, :naive_datetime)
    field(:utc_datetime_field, :utc_datetime)

    field(:simple_slug, SimpleSlug.Type)
    field(:simple_slug_force, SimpleSlugForce.Type)
    field(:multiple_sources_slug, MultipleSourcesSlug.Type)
    field(:id_field_slug, IdFieldSlug.Type)
    field(:datetime_slug, DateTimeSlug.Type)
    field(:multitype_slug, MultiTypeSlug.Type)
    field(:complex_slug, ComplexSlug.Type)
    field(:conditional_slug, ConditionalSlug.Type)
    field(:changing_slug, AlwaysChangeSlug.Type)
  end

  def changeset(model, params \\ :invalid) do
    all_fields = [
      :name,
      :company,
      :link_id,
      :float_amount,
      :decimal_amount,
      :flag,
      :date_field,
      :time_field,
      :naive_datetime_field,
      :utc_datetime_field,
      :simple_slug,
      :simple_slug_force,
      :multiple_sources_slug,
      :id_field_slug,
      :datetime_slug,
      :multitype_slug,
      :complex_slug,
      :conditional_slug,
      :changing_slug
    ]

    model
    |> cast(params, all_fields)
    |> validate_required([:name])
    |> SimpleSlug.maybe_generate_slug()
    |> MultipleSourcesSlug.maybe_generate_slug()
    |> IdFieldSlug.maybe_generate_slug()
    |> DateTimeSlug.maybe_generate_slug()
    |> MultiTypeSlug.maybe_generate_slug()
    |> ComplexSlug.maybe_generate_slug()
    |> ConditionalSlug.maybe_generate_slug()
    |> AlwaysChangeSlug.maybe_generate_slug()
    |> SimpleSlugForce.force_generate_slug()
  end
end

# Run tests:
ExUnit.start()
