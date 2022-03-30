defmodule Exzeitable.HTML.PaginationTest do
  @moduledoc false
  use TestWeb.DataCase, async: true
  use ExUnitProperties

  alias Exzeitable.HTML.Pagination

  @params %{module: TestWeb.PostTable, text: Exzeitable.Text.Default, assigns: %{}}

  describe "filter_pages/2" do
    test "returns no more than 7 buttons no matter the entry" do
      for pages <- 1..20 do
        button_count = Pagination.filter_pages(pages, 1) |> Enum.count()
        assert button_count <= 7
        button_count = Pagination.filter_pages(pages, 5) |> Enum.count()
        assert button_count <= 7
      end
    end

    test "returns the first, and last numbers, and the numbers surrounding the current page" do
      buttons = Pagination.filter_pages(12, 8)
      expected_result = [1, :dots, 7, 8, 9, :dots, 12]
      assert buttons == expected_result
    end
  end

  describe "build/1" do
    property "always returns html without error" do
      check all page <- positive_integer(),
                count <- integer(0..100_000),
                per_page <- positive_integer() do
        result =
          @params
          |> Map.merge(%{page: page, count: count, per_page: per_page})
          |> Pagination.build()

        assert {:safe, [_ | _]} = result
      end
    end
  end

  describe "page_count/1" do
    test "counts the number of pages" do
      assert 2 = Pagination.page_count(%{count: 10, per_page: 5})
    end

    test "counts partial pages" do
      assert 3 = Pagination.page_count(%{count: 11, per_page: 5})
    end

    property "always returns a positive integer" do
      check all page <- positive_integer(),
                count <- integer(0..100_000),
                per_page <- positive_integer() do
        result =
          @params
          |> Map.merge(%{page: page, count: count, per_page: per_page})
          |> Pagination.page_count()

        assert is_integer(result)
        assert result > 0
      end
    end
  end
end
