defmodule OnTheMapWeb.ItemControllerTest do
  use OnTheMapWeb.ConnCase

  alias OnTheMap.Core.Bid
  alias OnTheMap.Core.Item

  import OnTheMap.CoreFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :register_and_put_challenge

  describe "index" do
    test "lists all items", %{conn: conn} do
      top_bid_value = 500
      %Item{id: item_id} = item = item_fixture()

      %Bid{} = bid_fixture(%{value: 499, item_id: item_id})
      %Bid{} = bid_fixture(%{value: 250, item_id: item_id})
      %Bid{} = bid_fixture(%{value: top_bid_value, item_id: item_id})

      conn = get(conn, Routes.item_path(conn, :index))

      t0 = NaiveDateTime.to_iso8601(item.t0)
      t1 = NaiveDateTime.to_iso8601(item.t1)

      assert [%{"id" => ^item_id, "topBid" => ^top_bid_value, "t0" => ^t0, "t1" => ^t1}] = json_response(conn, 200)
    end

    test "with no items returns an empty list", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))

      assert [] = json_response(conn, 200)
    end
  end

  describe "show" do
    test "responds with single item info + bids attached to item", %{conn: conn} do
      %Item{id: item_id} = item = item_fixture()
      %Bid{value: bid_value, bidder_id: bidder_id} = bid_fixture(%{value: 499, item_id: item_id})

      conn = get(conn, Routes.item_path(conn, :show, item))

      assert %{"id" => ^item_id, "bids" => [bid_json]} = item_json = json_response(conn, 200)

      assert item_json["t0"] === NaiveDateTime.to_iso8601(item.t0)
      assert item_json["t1"] === NaiveDateTime.to_iso8601(item.t1)

      assert ~w(bids id t0 t1) == Map.keys(item_json)
      assert %{"value" => ^bid_value, "bidder" => ^bidder_id} = bid_json
    end

    test "raise an error if item not exists", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.item_path(conn, :show, 0))
      end
    end
  end
end
