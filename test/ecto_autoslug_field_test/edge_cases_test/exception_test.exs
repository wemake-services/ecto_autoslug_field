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

    def changeset(model, params \\ :invalid) do
      model
      |> cast(params, [:title, :slug])
      |> validate_required([:title])
      |> StringSource.maybe_generate_slug
    end
  end

  test "no sources is provided, exception" do
    assert_raise FunctionClauseError, fn ->
      Article.changeset(%Article{}, %{title: "News"})
    end
  end
end
