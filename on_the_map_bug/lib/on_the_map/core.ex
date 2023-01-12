defmodule OnTheMap.Core do
  @moduledoc """
  The module for interacting with items and bids
  """

  import Ecto.Query

  alias OnTheMap.Repo

  alias OnTheMap.Core.Bid
  alias OnTheMap.Core.Item

  def list_items() do
    Item
    |> join(:left, [item], bid in subquery(top_bid_query()), on: bid.item_id == item.id)
    |> select_merge([item, top_bid], %{item | top_bid: top_bid.value})
    |> Repo.all()
  end

  def get_item!(item_id) do
    Repo.get!(Item, item_id) |> Repo.preload(:bids)
  end

  def create_item(item_params) do
    %Item{}
    |> Item.changeset(item_params)
    |> Repo.insert()
  end

  def list_bids do
    Repo.all(Bid)
  end

  def get_bid!(id), do: Repo.get!(Bid, id)

  def create_bid(attrs \\ %{}) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> Repo.insert()
  end

  def top_bid(%Item{id: item_id}) do
    top_bid_query()
    |> where([bid], bid.item_id == ^item_id)
    |> preload(:bidder)
    |> Repo.one()
  end

  def top_bid_query() do
    Bid
    |> group_by([bid], bid.id)
    |> order_by([bid], fragment("max(value) desc"))
    |> limit(1)
  end
end
