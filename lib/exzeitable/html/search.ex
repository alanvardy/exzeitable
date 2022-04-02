defmodule Exzeitable.HTML.Search do
  @moduledoc "Build the search field part of the HTML"

  alias Exzeitable.HTML.Helpers
  alias Exzeitable.{Params, Text}
  alias Phoenix.HTML.Form

  @doc "Returns the HTML search form"
  @spec build(map) :: {:safe, iolist}
  def build(%{params: %Params{debounce: debounce} = params}) do
    if search_enabled?(params) do
      Form.form_for(
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
            Form.text_input(f, :search,
              placeholder: Text.text(params, :search),
              class: "exz-search-field",
              phx_debounce: debounce
            ),
            counter(params)
          ]
          |> Helpers.tag(:div, class: "exz-search-field-wrapper")
        end
      )
      |> Helpers.tag(:div, class: "exz-search-wrapper")
    else
      {:safe, [""]}
    end
  end

  defp counter(%Params{count: count}) do
    count
    |> Helpers.tag(:span, class: "exz-counter-field")
    |> Helpers.tag(:div, class: "exz-counter-field-wrapper")
  end

  # Returns true if any of the fields have search enabled
  defp search_enabled?(%Params{fields: fields}) do
    fields
    |> Enum.filter(fn {_k, field} -> Map.get(field, :search) end)
    |> Enum.any?()
  end
end
