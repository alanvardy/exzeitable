# defmodule TradeswayWeb.LiveTableDatabaseTest do
#   @moduledoc false
#   use Tradesway.DataCase, async: true
#   alias Tradesway.Client.Contact
#   alias TradeswayWeb.Helpers.LiveTable.Database
#   import Tradesway.Factory

#   @assigns %{
#     query: from(c in Contact),
#     parent: nil,
#     routes: TradeswayWeb.Router.Helpers,
#     repo: Tradesway.Repo,
#     path: :contact_path,
#     fields: [id: [], email: []],
#     action_buttons: [:new, :show, :edit],
#     belongs_to: nil,
#     per_page: 10,
#     module: TradeswayWeb.Live.Contact,
#     page: 1,
#     order: nil,
#     count: 0,
#     list: [],
#     search: ""
#   }

#   test "get_records/1 returns a list of items when searched" do
#     insert(:contact, last_name: "Dufus")
#     insert(:contact, last_name: "Dufus")
#     insert(:contact, last_name: "Dufus")

#     for _contact <- 1..5 do
#       insert(:contact)
#     end

#     db_count =
#       %{@assigns | search: "Dufus"}
#       |> Database.get_records()
#       |> Enum.count()

#     assert db_count == 3
#   end

#   test "get_records/1 returns a list of items" do
#     contacts =
#       for _contact <- 1..3 do
#         insert(:contact)
#       end

#     assert last_names(Database.get_records(@assigns)) == last_names(contacts)
#   end

#   test "get_records/1 offsets based on page number" do
#     for _contact <- 1..7 do
#       insert(:contact)
#     end

#     db_count =
#       %{@assigns | per_page: 5, page: 2}
#       |> Database.get_records()
#       |> Enum.count()

#     assert db_count == 2
#   end

#   test "get_records/1 orders queries" do
#     for _contact <- 1..3 do
#       insert(:contact)
#     end

#     first =
#       %{@assigns | order: [desc: :id]}
#       |> Database.get_records()

#     second =
#       %{@assigns | order: [asc: :id]}
#       |> Database.get_records()
#       |> Enum.reverse()

#     assert first == second
#   end

#   test "get_record_count/1 gets the number of records" do
#     for _contact <- 1..3 do
#       insert(:contact)
#     end

#     db =
#       @assigns
#       |> Database.get_record_count()

#     assert db == 3
#   end

#   test "prefix_string/1 removed non-characters and appends :*" do
#     assert Database.prefix_search("bananas") == "bananas:*"
#     assert Database.prefix_search("baNANas") == "baNANas:*"
#     assert Database.prefix_search("ba@NAN%as") == "baNANas:*"
#     assert Database.prefix_search("ba_@nan%as") == "bananas:*"
#   end

#   test "tsvector_string/1 turns a keyword list with field metadata into a string" do
#     generated =
#       [id: [search: true], name: [search: true], boogers: [search: false]]
#       |> Database.tsvector_string()

#     expected = "to_tsvector('english', id || ' ' || name) @@ to_tsquery(?)"
#     assert generated == expected
#   end

#   def last_names(contacts), do: contacts |> Enum.map(fn c -> Map.get(c, :last_name) end)
# end
