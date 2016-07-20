defmodule EctoAutoslugField.Slug do
  @moduledoc """
  This module defines all the required functions and modules to work with
  custom 'Slug' implementations.

  To create a custom 'Slug' field do:

    defmodule MyCustomSlug do
      use EctoAutoslugField.Slug, from: :name_field, to: :slug_field
    end

  It is also possible to override 'get_sources/2' and 'build_slug/1' functions
  which are part of the AutoslugField's API.
  """

  defmacro __using__(options) do
    caller = __CALLER__.module

    quote bind_quoted: [options: options, caller: caller] do
      use EctoAutoslugField.SlugGenerator
      alias Ecto.Changeset

      from = Keyword.get(options, :from, nil)
      to = Keyword.get(options, :to, :slug)
      always_change = Keyword.get(options, :always_change, false)

      # New Type:

      defmodule Module.concat(caller, "Type") do
        @behaviour Ecto.Type

        alias EctoAutoslugField.Type

        def type(), do: Type.type()
        def cast(value), do: Type.cast(value)
        def load(value), do: Type.load(value)
        def dump(value), do: Type.dump(value)
      end

      # Public functions:

      def maybe_generate_slug(changeset) do
        opts = [
          to: unquote(to),
          always_change: unquote(always_change),
        ]

        sources = unquote(from)
        sources = case sources do
          nil -> get_sources(changeset, opts)
          _ -> sources
        end

        maybe_generate_slug(changeset, sources, opts)
      end

      def unique_constraint(changeset, opts \\ []) do
        Changeset.unique_constraint(changeset, unquote(to), opts)
      end

      # Client API:

      def get_sources(_changeset, _opts) do
        raise "You must provide ':from' option or 'get_sources/2' function"
      end

      def build_slug(sources), do: super(sources)

      defoverridable [get_sources: 2, build_slug: 1]

    end
  end

end
