defmodule Exzeitable.Support.FileHelpers do
  @moduledoc false
  import ExUnit.Assertions

  @doc """
  Returns the `tmp_path` for tests.
  """
  @spec tmp_path :: String.t()
  def tmp_path do
    Path.expand("../../tmp", __DIR__)
  end

  @doc """
  Asserts a file was generated.
  """
  @spec assert_file(String.t()) :: boolean
  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  @doc """
  Asserts a file was generated and that it matches a given pattern.
  """
  @spec assert_file(binary, String.t() | function) :: any
  def assert_file(file, callback) when is_function(callback, 1) do
    assert_file(file)
    callback.(File.read!(file))
  end

  def assert_file(file, match) do
    assert_file(file, &assert(&1 =~ match))
  end
end
