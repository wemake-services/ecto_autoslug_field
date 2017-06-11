defmodule EctoAutoslugField.SlugTest.EdgeCases.EmptySources do
  use ExUnit.Case

  defmodule StringSource do
    use EctoAutoslugField.Slug, to: :slug

    def get_sources(_, _) do
      []
    end
  end

  defmodule Article do
    use Ecto.Schema
    import Ecto.Changeset

    schema "articles" do
      field :title, :string
      field :slug, StringSource.Type
    end

    def changeset(model, params \\ :invalid) do
      model
      |> cast(params, [:title, :slug])
      |> validate_required([:title])
      |> StringSource.maybe_generate_slug
    end
  end

  test "no sources is provided, exception" do
    article = Article.changeset(%Article{}, %{title: "News"})
    refute Map.has_key?(article.changes, :slug)
  end

  test "provided 'nil' source" do
    article = Article.changeset(%Article{}, %{some_bad_key: "News"})
    refute Map.has_key?(article.changes, :slug)
  end
end
