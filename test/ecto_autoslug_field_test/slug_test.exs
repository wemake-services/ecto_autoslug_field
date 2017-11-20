defmodule EctoAutoslugField.SlugTest do
  use ExUnit.Case
  alias EctoAutoslugField.Test.User

  @valid_attrs %{name: "Nikita Sobolev", company: "wemake.services",
    link_id: 1, date_field: ~N[2015-02-20 00:00:00], time_field: ~N[2000-01-01 19:50:07],
    naive_datetime_field: ~N[2015-01-21 23:34:07], utc_datetime_field: ~N[2015-11-03 03:14:07],
    float_amount: 2.31, decimal_amount: Decimal.new(4.765), flag: true}

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

  test "id field slug", %{user: user} do
    assert user.changes.id_field_slug == \
      "nikita-sobolev-wemake-services-1"
  end

  test "datetime field slug", %{user: user} do
    assert user.changes.datetime_slug == \
      "nikita-sobolev-wemake-services-2015-02-20-19-50-07-2015-01-21-23-34-07-2015-11-03-03-14-07z"
  end

  test "multitype field slug", %{user: user} do
    assert user.changes.multitype_slug == \
      "nikita-sobolev-wemake-services-2-31-4-765-true"
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

  test "unique_constraint sets the constraint", %{user: user} do
    alias EctoAutoslugField.Test.TestSchema.SimpleSlug
    constrained = user |> SimpleSlug.unique_constraint
    assert %{
      constraint: "user_simple_slug_index",
      field: :simple_slug,
      error: {"has already been taken", []},
      type: :unique,
      match: :exact
    } in constrained.constraints
  end
end
