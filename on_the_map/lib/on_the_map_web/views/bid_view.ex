defmodule OnTheMapWeb.BidView do
  use OnTheMapWeb, :view

  def render("create.json", %{top_bid: top_bid}) do
    %{
      topBid: top_bid.value,
      bidder: top_bid.bidder.id
    }
  end

  def render("for_item.json", %{bid: bid}) do
    %{
      value: bid.value,
      bidder: bid.bidder_id
    }
  end
end
