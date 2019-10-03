# defmodule TradeswayWeb.LiveTableFilterTest do
#   @moduledoc false
#   use Tradesway.DataCase, async: true
#   alias Tradesway.Client.Equipment
#   alias TradeswayWeb.Helpers.LiveTable.{Database, Filter}
#   import Tradesway.Factory

#   @assigns %{
#     query: from(e in Equipment, preload: [:site]),
#     parent: nil,
#     routes: TradeswayWeb.Router.Helpers,
#     repo: Tradesway.Repo,
#     path: :user_path,
#     fields: [id: [], email: []],
#     action_buttons: [:new, :show, :edit],
#     belongs_to: nil,
#     per_page: 50,
#     module: TradeswayWeb.Live.LiveTable,
#     page: 1,
#     order: nil,
#     count: 0,
#     list: [],
#     search: ""
#   }

#   test "parent_for/1 selects the parent for the item" do
#     site = insert(:site)
#     insert(:equipment, site: site)

#     assigns = %{@assigns | belongs_to: :site, list: Database.get_records(@assigns)}

#     db =
#       assigns
#       |> Map.get(:list)
#       |> List.first()
#       |> Filter.parent_for(assigns)

#     assert db.name == site.name
#   end

#   test "parent_for/1 raises an error when it cannot find the field" do
#     site = insert(:site)
#     insert(:equipment, site: site)

#     assigns = %{
#       @assigns
#       | list: Database.get_records(@assigns),
#         query: from(e in Equipment, select: [:id])
#     }

#     assert_raise RuntimeError,
#                  "You need to select the association in :belongs_to",
#                  fn ->
#                    assigns
#                    |> Map.get(:list)
#                    |> List.first()
#                    |> Filter.parent_for(assigns)
#                  end
#   end

#   test "filter_pages/2 returns no more than 7 buttons no matter the entry" do
#     for pages <- 1..20 do
#       button_count = Filter.filter_pages(1, pages) |> Enum.count()
#       assert button_count <= 7
#       button_count = Filter.filter_pages(5, pages) |> Enum.count()
#       assert button_count <= 7
#     end
#   end
# end
