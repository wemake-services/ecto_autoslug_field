# CHANGELOG

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
