# EctoAutoslugField

[![Build Status](https://travis-ci.org/sobolevn/ecto_autoslug_field.svg?branch=master)](https://travis-ci.org/sobolevn/ecto_autoslug_field)
[![Coverage Status](https://coveralls.io/repos/github/sobolevn/ecto_autoslug_field/badge.svg?branch=master)](https://coveralls.io/github/sobolevn/ecto_autoslug_field?branch=master)
[![Module Version](https://img.shields.io/hexpm/v/ecto_autoslug_field.svg)](https://hex.pm/packages/ecto_autoslug_field)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_autoslug_field/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_autoslug_field.svg)](https://hex.pm/packages/ecto_autoslug_field)
[![License](https://img.shields.io/hexpm/l/ecto_autoslug_field.svg)](https://github.com/sobolevn/ecto_autoslug_field/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/sobolevn/ecto_autoslug_field.svg)](https://github.com/sobolevn/ecto_autoslug_field/commits/master)

`ecto_autoslug_field` is a reusable [`Ecto`](https://github.com/elixir-ecto/ecto) library which can automatically create slugs from other fields. We use [`slugger`](https://github.com/h4cc/slugger) as a default slug-engine.

We only depend on the `ecto` package (we do not deal with `ecto_sql` at all).
We support `ecto >= 2.1 and ecto < 4`!

See [this blog post](https://sobolevn.me/2017/07/creating-slugs-for-ecto-schemas)
for more information.


## Installation

```elixir
def deps do
  [
    {:ecto_autoslug_field, "~> 2.0"}
  ]
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

See [this tutorial](https://sobolevn.me/2017/07/creating-slugs-for-ecto-schemas)
for some more examples.


## Changelog

See [CHANGELOG.md](./CHANGELOG.md).


## Copyright and License

Copyright (c) 2016 Nikita Sobolev

This library is released under the MIT License. See the [LICENSE.md](./LICENSE.md) file
for further details.
