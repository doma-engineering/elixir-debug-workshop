defmodule OnTheMap.CoreTest do
  use OnTheMap.DataCase

  alias OnTheMap.Core
  alias OnTheMap.Core.Bid

  import OnTheMap.CoreFixtures

  describe "bids" do
    @invalid_attrs %{value: nil}

    test "list_bids/0 returns all bids" do
      bid = bid_fixture()
      assert Core.list_bids() == [bid]
    end

    test "get_bid!/1 returns the bid with given id" do
      bid = bid_fixture()
      assert Core.get_bid!(bid.id) == bid
    end

    test "create_bid/1 with valid data creates a bid" do
      valid_attrs = Map.merge(%{value: 42}, default_bid_attrs())

      assert {:ok, %Bid{} = bid} = Core.create_bid(valid_attrs)
      assert bid.value == 42
    end

    test "create_bid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_bid(@invalid_attrs)
    end

    test "top_bid/1 return bid with max value for the given item" do
      item = item_fixture()

      _bid_1 = bid_fixture(%{value: 100, item_id: item.id})
      _bid_2 = bid_fixture(%{value: 1_000, item_id: item.id})
      _bid_3 = bid_fixture(%{value: 10_000, item_id: item.id})

      assert %Bid{value: 10_000} = Core.top_bid(item)
    end

    test "top_bid/1 returns nil if there isn't any bids at the moment" do
      item = item_fixture()

      assert is_nil(Core.top_bid(item))
    end
  end
end
