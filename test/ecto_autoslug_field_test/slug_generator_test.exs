defmodule EctoAutoslugField.SlugGeneratorTest do
  use ExUnit.Case
  import Ecto.Changeset

  import EctoAutoslugField.SlugGenerator
  alias EctoAutoslugField.Test.User

  @valid_attrs %{name: "Nikita Sobolev", company: "wemake.services"}

  setup do
    {:ok, %{
      user: User.changeset(%User{}, @valid_attrs),
      opts: [
        to: :slug,
        slug_builder: &build_slug/1
      ],
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
end
