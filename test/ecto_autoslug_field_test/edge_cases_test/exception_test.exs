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
    assert_raise FunctionClauseError, fn ->
      Article.changeset(%Article{}, %{title: "News"})
    end
  end
end
