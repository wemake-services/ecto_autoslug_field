defmodule EctoAutoslugField.TypeTest do
  use ExUnit.Case
  alias EctoAutoslugField.Type

  doctest EctoAutoslugField

  test "basic type" do
    assert Type.type() == :string
  end

  test "cast string" do
    assert Type.cast("value") == {:ok, "value"}
  end

  test "cast error" do
    assert Type.cast(:atom) == :error
  end

  test "load string" do
    assert Type.load("value") == {:ok, "value"}
  end

  test "load error" do
    assert Type.load([]) == :error
  end

  test "dump string" do
    assert Type.dump("value") == {:ok, "value"}
  end

  test "dump error" do
    assert Type.dump(%{}) == :error
  end
end
