defmodule OnTheMapWeb.BidControllerTest do
  use OnTheMapWeb.ConnCase

  import OnTheMap.CoreFixtures

  alias OnTheMap.Auth.Identity
  alias OnTheMap.Core.Bid

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :register_and_put_challenge

  describe "create bid" do
    setup %{conn: conn} do
      item = item_fixture()

      %{conn: conn, item: item}
    end

    test "renders placed bid if it is a best bid", %{conn: conn, item: item, identity: %Identity{id: best_bidder_id}} do
      bid_fixture(%{value: 20, item_id: item.id})

      conn = post(conn, Routes.bid_path(conn, :create, item.id), %{value: 1_000})
      assert %{"topBid" => 1_000, "bidder" => ^best_bidder_id} = json_response(conn, 201)
    end

    test "renders best bid otherwise", %{conn: conn, item: item} do
      %Bid{bidder_id: bidder_id, value: best_bid_value} = bid_fixture(%{value: 6_000, item_id: item.id})

      conn = post(conn, Routes.bid_path(conn, :create, item.id), %{value: 450})
      assert %{"topBid" => ^best_bid_value, "bidder" => ^bidder_id} = json_response(conn, 201)
    end
  end
end
