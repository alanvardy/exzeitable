defmodule Exzeitable.HTML.Helpers do
  @moduledoc "Helpers that are needed across multiple modules in the HTML context"

  defmacro __using__(_opts) do
    quote do
      import Phoenix.HTML.Tag, only: [content_tag: 3]
      import Phoenix.HTML.Link, only: [link: 2]
      import Phoenix.HTML.Form, only: [form_for: 4, text_input: 3]
      import Exzeitable.Text, only: [text: 2, text: 3]

      # Used everywhere to make it easier to pipe HTML chunks into each other
      @spec cont(any(), atom, keyword) :: {:safe, iolist}
      defp cont(body, tag, opts), do: content_tag(tag, body, opts)

      # Used to build lists
      @spec prepend(list, any) :: list
      defp prepend(list, element), do: [element | list]
    end
  end
end
