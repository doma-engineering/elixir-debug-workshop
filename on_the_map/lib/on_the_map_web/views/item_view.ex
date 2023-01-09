defmodule OnTheMapWeb.ItemView do
  use OnTheMapWeb, :view

  alias OnTheMapWeb.ItemView
  alias OnTheMapWeb.BidView

  def render("index.json", %{items: items}) do
    render_many(items, ItemView, "index_item.json")
  end

  def render("show.json", %{item: item}) do
    %{
      id: item.id,
      t0: item.t0,
      t1: item.t1,
      bids: render_many(item.bids, BidView, "for_item.json", as: :bid)
    }
  end

  def render("index_item.json", %{item: item}) do
    %{
      id: item.id,
      t0: item.t0,
      t1: item.t1,
      topBid: item.top_bid
    }
  end
end
