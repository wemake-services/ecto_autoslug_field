# EctoAutoslugField

[![Build Status](https://travis-ci.org/sobolevn/ecto_autoslug_field.svg?branch=master)](https://travis-ci.org/sobolevn/ecto_autoslug_field) [![Coverage Status](https://coveralls.io/repos/github/sobolevn/ecto_autoslug_field/badge.svg?branch=master)](https://coveralls.io/github/sobolevn/ecto_autoslug_field?branch=master) [![Hex Version](https://img.shields.io/hexpm/v/ecto_autoslug_field.svg)](https://hex.pm/packages/ecto_autoslug_field) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

`ecto_autoslug_field` is a reusable [`Ecto`](https://github.com/elixir-ecto/ecto) library which can automatically create slugs from other fields. We use [`slugger`](https://github.com/h4cc/slugger) as a default slug-engine.


## Installation

```elixir
def deps do
  [{:ecto_autoslug_field, "~> 0.5"}]
end
```


## Options

There are several options to configure.

Required:

- `:to` - represents the slug field name where to save value to

Optional:

- `:from` - represents the source fields from which to build slug, if this option is not set you have to override `get_sources/2` function
- `:always_change` - if this option is set slug will be recreated from the given sources each time `maybe_generate_slug` function is called


## Functions

- `get_sources/2` - this function is used to get sources for the slug, [docs](https://hexdocs.pm/ecto_autoslug_field/EctoAutoslugField.SlugBase.html#get_sources/2).
- `build_slug/2` - this function is a place to modify the result slug, [docs](https://hexdocs.pm/ecto_autoslug_field/EctoAutoslugField.SlugBase.html#build_slug/2).


## Examples

The simplest example:

```elixir
defmodule EctoSlugs.Blog.Article.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule EctoSlugs.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias EctoSlugs.Blog.Article
  alias EctoSlugs.Blog.Article.TitleSlug

  schema "blog_articles" do
    field :breaking, :boolean, default: false
    field :content, :string
    field :title, :string

    field :slug, TitleSlug.Type

    timestamps()
  end

  def changeset(%Article{} = article, attrs) do
    article
    |> cast(attrs, [:title, :content, :breaking])
    |> validate_required([:title, :content])
    |> unique_constraint(:title)
    |> TitleSlug.maybe_generate_slug
    |> TitleSlug.unique_constraint
  end
end
```

See [this tutorial](https://medium.com/wemake-services/creating-slugs-for-ecto-schemas-7349513410f0)
for some more examples.


## Changelog

See [CHANGELOG.md](https://github.com/sobolevn/ecto_autoslug_field/blob/master/CHANGELOG.md).


## License

MIT. Please see [LICENSE.md](https://github.com/sobolevn/ecto_autoslug_field/blob/master/LICENSE.md) for licensing details.
