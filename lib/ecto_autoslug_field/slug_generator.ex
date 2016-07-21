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

      @doc """
      This is a public wrapper around `do_build_slug/1` functions.

      It is marked as `defoverridable` and can be overridden.
      """
      @spec build_slug(Keyword.t) :: String.t
      def build_slug(sources) do
        do_build_slug(sources)
      end

      defoverridable [build_slug: 1]

      @doc """
      This function conditionally generates slug.

      This function prepares sources and then calls `do_generate_slug/3`.
      """
      @spec maybe_generate_slug(
        Changeset.t, atom() | list(), Keyword.t) :: Changeset.t
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

      # Private functions:

      defp do_generate_slug(changeset, sources, opts) do
        always_change = Keyword.get(opts, :always_change, false)
        slug_key = Keyword.get(opts, :to)
        slug_field = Map.get(changeset.model, slug_key)
        slug_string = build_slug(sources)

        cond do
          always_change ->
            put_change(changeset, slug_key, slug_string)
          slug_field == nil and has_value?(slug_string) ->
            put_change(changeset, slug_key, slug_string)
          true -> changeset
        end
      end

      defp get_field_data(changeset, source, opts) when is_atom(source) do
        always_change = Keyword.get(opts, :always_change, false)
        source_value = get_change(changeset, source, nil)

        if always_change do
          source_value || changeset.model[source]
        else
          source_value
        end
      end
      defp get_field_data(_, source, _) when is_binary(source), do: source

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
