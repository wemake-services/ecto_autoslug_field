defmodule EctoAutoslugField.SlugGenerator do
  @moduledoc """
  This module works with slugs itself. It is just a wrapper around 'Slugger'.

  It is suited for inner use.
  """

  defmacro __using__(_) do
    quote do
      import Ecto.Changeset, only: [
        put_change: 3,
        get_change: 3,
      ]

      def build_slug(sources) do
        do_build_slug(sources)
      end

      defoverridable [build_slug: 1]

      def maybe_generate_slug(changeset, source, opts) when is_atom(source) do
        source_value = get_field_data(changeset, source, opts)
        do_generate_slug(changeset, source_value, opts)
      end
      def maybe_generate_slug(changeset, sources, opts) do
        cleaned_sources =
          sources
          |> Enum.map(fn(v) -> get_field_data(changeset, v, opts) end)
          |> Enum.filter(fn(v) -> v != nil end)

        do_generate_slug(changeset, cleaned_sources, opts)
      end

      defp do_generate_slug(changeset, sources, opts) do
        always_change = Keyword.get(opts, :always_change, false)
        slug_key = Keyword.get(opts, :to)
        slug_field = Map.get(changeset.model, slug_key)
        slug_string = build_slug(sources)

        cond do
          always_change and has_value?(slug_string) ->
            put_change(changeset, slug_key, slug_string)
          slug_field == nil and has_value?(slug_string) ->
            put_change(changeset, slug_key, slug_string)
          true -> changeset
        end
      end

      defp get_field_data(changeset, source, opts) do
        always_change = Keyword.get(opts, :always_change, false)
        source_value = get_change(changeset, source, nil)

        if always_change do
          source_value || changeset.model[source]
        else
          source_value
        end
      end

      defp has_value?(nil), do: false
      defp has_value?(string) do
        String.strip(string) != ""
      end

      defp do_build_slug(source) when is_binary(source) do
        source |> Slugger.slugify_downcase
      end
      defp do_build_slug(sources) do
        sources |> Enum.join("-") |> Slugger.slugify_downcase
      end

    end
  end
end
