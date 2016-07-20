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
