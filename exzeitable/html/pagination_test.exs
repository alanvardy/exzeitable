defmodule Exzeitable.HTML.PaginationTest do
  @moduledoc false
  use TestWeb.DataCase, async: true

  alias Exzeitable.HTML.Pagination

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
end
