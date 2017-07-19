# CHANGELOG

## Version 0.3.1

### Improvements

- Adds `build_slug/2` to accept the original `changeset` as the second argument, it still receives list of `sources` as the first argument
- Updates `build_slug/1` inner logic

### Documentation

- Updates `README.md` with the new example
- Updates docs to handle new changes
- Updates `CONTRIBUTING.md` with 'Development' section

### Testing

- Adds new test cases to cover `build_slug/2`


## Version 0.3.0

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


## Version 0.2.1

- Added `credo` support
- Added `elixir` version 1.4 support


## Version 0.2.0

- Since this version only `ecto` 2 and above are supported
- Updated docs on how to use this package with older `ecto`
- Credo is not working with this release, please see https://github.com/sobolevn/ecto_autoslug_field/issues/5


## Version 0.1.3

- Now `build_slug/1` is called only when needed, changed docs appropriately
- Replaced `cond` inside `do_generate_slug/3` with more obvious `if`
- Changed tests structure, reached 100% coverage


## Version 0.1.2

- Moved `get_sources/2` and `build_slug/1` definitions into `SlugBase`
- Added `## Options` and `## Function` section to the `README.md`
- Added new tests


## Version 0.1.1

- Since the docs inside `__using__` were unreachable the design of application was changed
- Now `opts` keyword-list contains `:slug_build` parameter with a `build_slug` callback
- Also `coverage` information is updated, since more code is reachable now


## Version 0.1.0

- Initial release
