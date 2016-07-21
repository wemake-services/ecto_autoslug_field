defmodule EctoAutoslugField.SlugTest do
  use ExUnit.Case
  alias EctoAutoslugField.Test.User

  @valid_attrs %{name: "Nikita Sobolev", company: "wemake.services"}

  setup do
    {:ok, %{user: User.changeset(%User{}, @valid_attrs)}}
  end

  test "changeset is valid", %{user: user} do
    assert user.valid?
  end

  test "simple slug", %{user: user} do
    assert user.changes.simple_slug == "nikita-sobolev"
  end

  test "multiple sources slug", %{user: user} do
    assert user.changes.multiple_sources_slug == \
      "nikita-sobolev-wemake-services"
  end

  test "multiple source when some are not set" do
    user = User.changeset(%User{}, %{name: "Nikita Sobolev"})
    assert user.changes.multiple_sources_slug == "nikita-sobolev"
  end

  test "complex slug", %{user: user} do
    assert user.changes.complex_slug == "nikita+sobolev+wemake+services"
  end

  test "conditional slug", %{user: user} do
    assert user.changes.conditional_slug == \
      "nikita-sobolev-wemake-services"

    no_company = User.changeset(%User{}, %{name: "Nikita Sobolev"})
    assert no_company.changes.conditional_slug == "nikita-sobolev"
  end

  test "always changing slug" do
    user = %User{
      id: 1,
      changing_slug: "nikita-sobolev",
      name: "Nikita Sobolev",
    }

    changeset = User.changeset(user, %{name: "Sobolev Nikita"})
    assert changeset.changes.changing_slug == "sobolev-nikita"
  end

  test "basic slugs do not change" do
    user = %User{
      id: 1,
      name: "Nikita Sobolev",
      simple_slug: "nikita-sobolev",
      conditional_slug: "nikita-sobolev",
      complex_slug: "nikita+sobolev+wemake+services",
      multiple_sources_slug: "nikita-sobolev",
    }

    changeset = User.changeset(user, %{name: "Sobolev Nikita"})
    refute Map.has_key?(changeset.changes, :simple_slug)
    refute Map.has_key?(changeset.changes, :conditional_slug)
    refute Map.has_key?(changeset.changes, :multiple_sources_slug)
    refute Map.has_key?(changeset.changes, :complex_slug)
  end
end


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

defmodule EctoAutoslugField.SlugTest.EdgeCases.Exception do
  use ExUnit.Case

  defmodule StringSource do
    use EctoAutoslugField.Slug, to: :slug
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

  test "no sources is provided, exception" do
    assert_raise RuntimeError, fn ->
      Article.changeset(%Article{}, %{title: "News"})
    end
  end
end
