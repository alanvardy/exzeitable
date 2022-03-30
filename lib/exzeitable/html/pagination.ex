defmodule Exzeitable.HTML.Pagination do
  @moduledoc """
   For building out the pagination buttons above and below the table
  """
  use Exzeitable.HTML.Helpers

  @type name :: :next | :previous | :dots | pos_integer
  @type params :: %{
          :page => pos_integer,
          :count => non_neg_integer,
          :per_page => pos_integer,
          optional(atom) => any()
        }

  @doc "Builds the pagination selector with page numbers, next and back etc."
  @spec build(params) :: {:safe, iolist}
  def build(%{page: page} = assigns) do
    pages = page_count(assigns)
    previous_button = paginate_button(assigns, :previous, page, pages)
    numbered_buttons = numbered_buttons(assigns, page, pages)
    next_button = paginate_button(assigns, :next, page, pages)

    ([previous_button] ++ numbered_buttons ++ [next_button])
    |> cont(:ul, class: "exz-pagination-ul")
    |> cont(:nav, class: "exz-pagination-nav")
  end

  # Handle the case where there is only a single page, just gives us some disabled buttons
  @spec numbered_buttons(params, pos_integer, non_neg_integer) :: [{:safe, iolist}]
  defp numbered_buttons(assigns, page, pages) do
    pages
    |> filter_pages(page)
    |> Enum.map(&paginate_button(assigns, &1, page, pages))
  end

  @doc "A partial page is still a page."
  @spec page_count(params) :: pos_integer
  def page_count(%{count: count, per_page: per_page}) do
    if rem(count, per_page) > 0 do
      div(count, per_page) + 1
    else
      count |> div(per_page) |> max(1)
    end
  end

  @spec paginate_button(params, name, pos_integer, pos_integer) :: {:safe, iolist}
  defp paginate_button(assigns, :next, page, pages) when page == pages do
    assigns
    |> text(:next)
    |> cont(:a, class: "exz-pagination-a", tabindex: "-1")
    |> cont(:li, class: "exz-pagination-li-disabled")
  end

  defp paginate_button(assigns, :previous, 1, _pages) do
    assigns
    |> text(:previous)
    |> cont(:a, class: "exz-pagination-a", tabindex: "-1")
    |> cont(:li, class: "exz-pagination-li-disabled")
  end

  defp paginate_button(_assigns, :dots, _page, _pages) do
    cont("....", :a, class: "exz-pagination-a exz-pagination-width", tabindex: "-1")
    |> cont(:li, class: "exz-pagination-li-disabled")
  end

  defp paginate_button(assigns, :next, page, _pages) do
    assigns
    |> text(:next)
    |> cont(:a,
      class: "exz-pagination-a",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page + 1
    )
    |> cont(:li, class: "exz-pagination-li")
  end

  defp paginate_button(assigns, :previous, page, _pages) do
    assigns
    |> text(:previous)
    |> cont(:a,
      class: "exz-pagination-a",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page - 1
    )
    |> cont(:li, class: "exz-pagination-li")
  end

  defp paginate_button(_assigns, page, page, _pages) when is_integer(page) do
    cont(page, :a, class: "exz-pagination-a exz-pagination-width")
    |> cont(:li, class: "exz-pagination-li-active")
  end

  defp paginate_button(_assigns, page, _page, _pages) when is_integer(page) do
    cont(page, :a,
      class: "exz-pagination-a exz-pagination-width",
      style: "cursor: pointer",
      "phx-click": "change_page",
      "phx-value-page": page
    )
    |> cont(:li, class: "exz-pagination-li")
  end

  @doc "Selects the page buttons we need for pagination"
  def filter_pages(pages, _page) when pages <= 7, do: 1..pages

  def filter_pages(pages, page) when page in [1, 2, 3, pages - 2, pages - 1, pages] do
    [1, 2, 3, :dots, pages - 2, pages - 1, pages]
  end

  def filter_pages(pages, page) do
    [1, :dots] ++ [page - 1, page, page + 1] ++ [:dots, pages]
  end
end
