defmodule Exzeitable.HTML.Helpers do
  @moduledoc "Helpers that are needed across multiple modules in the HTML context"

  alias Phoenix.HTML.Tag

  @doc "Replacement for content_tag to make it easier to pipe HTML chunks into each other"
  @spec tag(any, atom, keyword) :: {:safe, iolist}
  def tag(body, tag, opts), do: Tag.content_tag(tag, body, opts)
end
