defmodule Exzeitable.SearchParameters do
  @moduledoc "Rust NIF for processing search parameters. Find in /native/searchparameters"

  use Rustler, otp_app: :exzeitable, crate: "searchparameters"

  # When your NIF is loaded, it will override this function.
  def convert(_string), do: :erlang.nif_error(:nif_not_loaded)
end
