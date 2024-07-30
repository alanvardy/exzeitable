defmodule Exzeitable.HTML.Pagination do
  @moduledoc """
   For building out the pagination buttons above and below the table
  """

  alias Exzeitable.HTML.Helpers
  alias Exzeitable.{HTML, Params, Text}

  @type name :: :next | :previous | :dots | pos_integer
  @type page :: pos_integer
  @type pages :: pos_integer

  @doc "Builds the pagination selector with page numbers, next and back etc."
  @spec build(Params.t()) :: {:safe, iolist}
  def build(%Params{page: page} = params) do
    pages = page_count(params)
    previous_button = paginate_button(params, :previous, page, pages)
    numbered_buttons = numbered_buttons(params, page, pages)
    next_button = paginate_button(params, :next, page, pages)

    ([previous_button] ++ numbered_buttons ++ [next_button])
    |> Helpers.tag(:ul, class: HTML.class(params, "exz-pagination-ul"))
    |> Helpers.tag(:nav, class: HTML.class(params, "exz-pagination-nav"))
  end

  # Handle the case where there is only a single page, just gives us some disabled buttons
  @spec numbered_buttons(Params.t(), page, pages) :: [{:safe, iolist}]
  defp numbered_buttons(params, page, pages) do
    pages
    |> filter_pages(page)
    |> Enum.map(&paginate_button(params, &1, page, pages))
  end

  @doc "A partial page is still a page."
  @spec page_count(Params.t()) :: pages
  def page_count(%Params{count: count, per_page: per_page}) do
    if rem(count, per_page) > 0 do
      div(count, per_page) + 1
    else
      count |> div(per_page) |> max(1)
    end
  end

  @spec paginate_button(Params.t(), name, page, pages) :: {:safe, iolist}
  defp paginate_button(%Params{} = params, :next, page, page) do
    params
    |> Text.text(:next)
    |> Helpers.tag(:a, class: HTML.class(params, "exz-pagination-a"), tabindex: "-1")
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li-disabled"))
  end

  defp paginate_button(%Params{} = params, :previous, 1, _pages) do
    params
    |> Text.text(:previous)
    |> Helpers.tag(:a, class: HTML.class(params, "exz-pagination-a"), tabindex: "-1")
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li-disabled"))
  end

  defp paginate_button(params, :dots, _page, _pages) do
    "...."
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-pagination-a exz-pagination-width"),
      tabindex: "-1"
    )
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li-disabled"))
  end

  defp paginate_button(%Params{} = params, :next, page, _pages) do
    params
    |> Text.text(:next)
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-pagination-a"),
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page + 1
    )
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li"))
  end

  defp paginate_button(%Params{} = params, :previous, page, _pages) do
    params
    |> Text.text(:previous)
    |> Helpers.tag(:a,
      class: HTML.class(params, "exz-pagination-a"),
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page - 1
    )
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li"))
  end

  defp paginate_button(params, page, page, _pages) when is_integer(page) do
    Helpers.tag(page, :a, class: HTML.class(params, "exz-pagination-a exz-pagination-width"))
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li-active"))
  end

  defp paginate_button(params, page, _page, _pages) when is_integer(page) do
    Helpers.tag(page, :a,
      class: HTML.class(params, "exz-pagination-a exz-pagination-width"),
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page
    )
    |> Helpers.tag(:li, class: HTML.class(params, "exz-pagination-li"))
  end

  @doc "Selects the page buttons we need for pagination"
  @spec filter_pages(pos_integer, pos_integer) :: [pos_integer | :dots]
  def filter_pages(pages, _page) when pages <= 7, do: Enum.to_list(1..pages)

  def filter_pages(pages, page) when page in [1, 2, 3, pages - 2, pages - 1, pages] do
    [1, 2, 3, :dots, pages - 2, pages - 1, pages]
  end

  def filter_pages(pages, page) do
    [1, :dots, page - 1, page, page + 1, :dots, pages]
  end
end
