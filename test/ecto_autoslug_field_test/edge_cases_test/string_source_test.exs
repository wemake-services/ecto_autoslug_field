defmodule EctoAutoslugField.SlugTest.EdgeCases.String do
  use ExUnit.Case

  defmodule StringSource do
    use EctoAutoslugField.Slug, to: :slug

    def get_sources(_changeset, _opts), do: [:title, "read", "online"]
  end

  defmodule Article do
    use Ecto.Schema
    import Ecto.Changeset

    schema "articles" do
      field(:title, :string)
      field(:slug, StringSource.Type)
    end

    def changeset(model, params \\ :invalid) do
      model
      |> cast(params, [:title, :slug])
      |> validate_required([:title])
      |> StringSource.maybe_generate_slug()
    end
  end

  setup do
    {:ok, %{article: Article.changeset(%Article{}, %{title: "News"})}}
  end

  test "string sources", %{article: article} do
    assert article.changes.slug == "news-read-online"
  end
end
