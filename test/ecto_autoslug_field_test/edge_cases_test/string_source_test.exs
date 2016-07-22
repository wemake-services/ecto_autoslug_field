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
      field :title, :string
      field :slug, StringSource.Type
    end

    @required_fields ~w(title)
    @optional_fields ~w(slug)

    def changeset(model, params \\ :empty) do
      model
      |> cast(params, @required_fields, @optional_fields)
      |> StringSource.maybe_generate_slug
    end
  end

  setup do
    {:ok, %{article: Article.changeset(%Article{}, %{title: "News"})}}
  end

  test "string sources", %{article: article} do
    assert article.changes.slug == "news-read-online"
  end
end
