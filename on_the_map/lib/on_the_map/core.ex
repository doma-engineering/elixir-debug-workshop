defmodule OnTheMap.Core do
  @moduledoc """
  The module for interacting with items and bids
  """

  import Ecto.Query
  import DynHacks

  alias OnTheMap.Repo

  alias OnTheMap.Core.Bid
  alias OnTheMap.Core.Item

  require Logger

  @doc """
  Get list of items and populates top_bid and bidder fields in such way that top_bid is the highest bid value and bidder is the id of the bidder.

  This is equivalent of the following query:

  WITH max_bids as (
      SELECT item_id, bidder_id, MAX(value) as top_bid
      FROM bids
      GROUP BY item_id, bidder_id
      ORDER BY top_bid DESC
  )
  SELECT items.*, max_bids.top_bid, max_bids.bidder_id as bidder
  FROM items
  JOIN max_bids on items.id = max_bids.item_id
  ORDER BY max_bids.top_bid DESC;
  """
  def top_bids_per_bidder() do
    from(i in Item,
      join: mb in subquery(top_bid_query()),
      on: i.id == mb.item_id,
      select_merge: %{i | top_bid: mb.value, bidder: mb.bidder_id},
      order_by: [desc: mb.value]
    )
  end

  @doc """
  This function takes raw data from Repo.all(), for example:

  ```
  [{"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":990},
  {"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":978},
  {"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":970},
  {"id":2,"t0":"2023-01-12T00:21:32","t1":"2023-01-12T00:22:02","topBid":969},
  {"id":3,"t0":"2023-01-12T00:25:54","t1":"2023-01-12T00:26:24","topBid":961},
  {"id":2,"t0":"2023-01-12T00:21:32","t1":"2023-01-12T00:22:02","topBid":938},
  {"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":934},
  {"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":925},
  {"id":2,"t0":"2023-01-12T00:21:32","t1":"2023-01-12T00:22:02","topBid":921},
  {"id":2,"t0":"2023-01-12T00:21:32","t1":"2023-01-12T00:22:02","topBid":920},
  ```

  and only leaves the top bids for each ID. The result is:

  ```
  [{"id":1,"t0":"2023-01-12T00:16:56","t1":"2023-01-12T00:17:26","topBid":990},
  {"id":2,"t0":"2023-01-12T00:21:32","t1":"2023-01-12T00:22:02","topBid":969},
  {"id":3,"t0":"2023-01-12T00:25:54","t1":"2023-01-12T00:26:24","topBid":961}]
  ```
  """

  def list_items do
    top_bids_per_bidder()
    |> Repo.all()
    # Finally we reduce the list of items to only the top bids
    |> Enum.reduce(%{}, fn item, acc ->
      if is_nil(Map.get(acc, item.id)) do
        Map.put(acc, item.id, item)
      else
        Map.update(acc, item.id, item, fn _ ->
          if item.top_bid > acc[item.id].top_bid do
            item
          else
            acc[item.id]
          end
        end)
      end
    end)
    |> Map.values()
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
    from(b in Bid,
      select: %{
        item_id: b.item_id,
        bidder_id: b.bidder_id,
        value: b.value
      },
      order_by: [desc: :value]
    )
  end
end
