defmodule EctoAutoslugField.SlugGeneratorTest.Override do
  use EctoAutoslugField.SlugGenerator

  def build_slug(_) do
    "test-slug"
  end
end

defmodule EctoAutoslugField.SlugGeneratorTest do
  use ExUnit.Case
  import Ecto.Changeset

  use EctoAutoslugField.SlugGenerator
  alias EctoAutoslugField.Test.User

  @valid_attrs %{name: "Nikita Sobolev", company: "wemake.services"}

  setup do
    {:ok, %{
      user: User.changeset(%User{}, @valid_attrs),
      opts: [to: :slug]
    }}
  end

  test "maybe_generate_slug with single source", fixture do
    changeset = maybe_generate_slug(
      fixture.user, :name, fixture.opts)
    assert changeset.changes.slug == "nikita-sobolev"
  end

  test "maybe_generate_slug with multiple sources", fixture do
    changeset = maybe_generate_slug(
      fixture.user, [:name, :company], fixture.opts)
    assert changeset.changes.slug == "nikita-sobolev-wemake-services"
  end

  test "build_slug override", fixture do
    alias EctoAutoslugField.SlugGeneratorTest.Override

    changeset = Override.maybe_generate_slug(
      fixture.user, [:name, :company], fixture.opts)
    assert changeset.changes.slug == "test-slug"
  end

end
