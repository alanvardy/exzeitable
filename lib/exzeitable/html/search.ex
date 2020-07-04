defmodule Exzeitable.HTML.Search do
  @moduledoc "Build the search field part of the HTML"

  use Exzeitable.HTML.Helpers

  @spec build(map) :: {:safe, iolist}
  def build(%{debounce: debounce} = assigns) do
    if search_enabled?(assigns) do
      form_for(
        :search,
        "#",
        # onkeypress to disable enter key in search field
        [
          phx_change: :search,
          class: "exz-search-form",
          onkeypress: "return event.keyCode != 13;"
        ],
        fn f ->
          [
            text_input(f, :search,
              placeholder: text(assigns, :search),
              class: "exz-search-field",
              phx_debounce: debounce
            ),
            counter(assigns)
          ]
          |> cont(:div, class: "exz-search-field-wrapper")
        end
      )
      |> cont(:div, class: "exz-search-wrapper")
    else
      ""
    end
  end

  defp counter(%{count: count}) do
    count
    |> cont(:span, class: "exz-counter-field")
    |> cont(:div, class: "exz-counter-field-wrapper")
  end

  # Returns true if any of the fields have search enabled
  defp search_enabled?(%{fields: fields}) do
    fields
    |> Enum.filter(fn {_k, field} -> Map.get(field, :search) end)
    |> Enum.any?()
  end
end
