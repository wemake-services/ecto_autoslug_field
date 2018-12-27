defmodule EctoAutoslugField.SlugTest.EdgeCases.Arity2 do
  use ExUnit.Case

  defmodule StringSource do
    use EctoAutoslugField.Slug, to: :slug, from: :title

    def build_slug(sources) do
      sources
      |> super()
      |> String.replace("-", "*")
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

  setup do
    {:ok, %{article: Article.changeset(
      %Article{}, %{"title" => "Some article title"})
    }}
  end

  test "changeset is valid", %{article: article} do
    assert article.valid?
  end

  test "build_slug/2 is working", %{article: article} do
    assert article.changes.slug == "some*article*title"
  end
end
