# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v2.0.1 - 2019-10-16

### Bugfixes

- Fixed warnings with `ecto>=3.2`, see [#101](https://github.com/sobolevn/ecto_autoslug_field/pull/101)


## v2.0.0 - 2019-07-08

Breaking features:

- Now supports `elixir>=1.6`
- Now support only `ecto>=3.1`

### Improvements

- Adds `mix format`


## v1.0.0 - 2018-12-28

### Improvements

- Adds support for `ecto >= 3.0`
- Adds official support for `elixir == 1.6` and `elixir == 1.7`


## v0.5.1 - 2018-05-21

### Documentation

- Updates docs on using `force_update_slug`


## v0.5.0 - 2018-05-21

### Improvements

- Adds `force_generate_slug` function to the client API. This function may be used when the `always_change` option of the slug is maybe not set to `true` but you want to override this setting on the given changeset and force regeneration of the slug
- Updates multiple dependencies


## v0.4.0 - 2017-11-23

### Improvements

- Adds support for [numeric, datetime and date fields](https://github.com/sobolevn/ecto_autoslug_field/pull/18)
- Updates dependencies, now supports `ecto >= 2.1`

### Documentation

- Updates `README.md` with the new `ecto` version

### Testing

- Adds new test cases to cover new field types


## v0.3.1 - 2017-07-19

### Improvements

- Adds `build_slug/2` to accept the original `changeset` as the second argument, it still receives list of `sources` as the first argument
- Updates `build_slug/1` inner logic

### Documentation

- Updates `README.md` with the new example
- Updates docs to handle new changes
- Updates `CONTRIBUTING.md` with 'Development' section

### Testing

- Adds new test cases to cover `build_slug/2`


## v0.3.0 - 2017-06-11

### Changes

- *breaking* Updates `mix.exs` with new dependencies, closes [#14](https://github.com/sobolevn/ecto_autoslug_field/issues/14)
- *breaking* Drops `elixir` version 1.2 and `otp` version 17 support

### Improvements

- Updates `cast/4` functions to `cast/3` functions (new Ecto)
- Updates `credo` version and `.credo.exs` config
- Updates `.travis.yml` with credo and new `otp` release

### Bugs

- Fixes dialyxer issues, closes [#10](https://github.com/sobolevn/ecto_autoslug_field/issues/10)

### Documentation

- Updates docs, fixes spelling


## v0.2.1 - 2017-02-01

- Added `credo` support
- Added `elixir` version 1.4 support


## v0.2.0 - 2016-11-02

- Since this version only `ecto` 2 and above are supported
- Updated docs on how to use this package with older `ecto`
- Credo is not working with this release, please see https://github.com/sobolevn/ecto_autoslug_field/issues/5


## v0.1.3 - 2016-07-22

- Now `build_slug/1` is called only when needed, changed docs appropriately
- Replaced `cond` inside `do_generate_slug/3` with more obvious `if`
- Changed tests structure, reached 100% coverage


## v0.1.2 - 2016-07-21

- Moved `get_sources/2` and `build_slug/1` definitions into `SlugBase`
- Added `## Options` and `## Function` section to the `README.md`
- Added new tests


## v0.1.1 - 2016-07-21

- Since the docs inside `__using__` were unreachable the design of application was changed
- Now `opts` keyword-list contains `:slug_build` parameter with a `build_slug` callback
- Also `coverage` information is updated, since more code is reachable now


## v0.1.0 - 2016-07-21

- Initial release
