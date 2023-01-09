defmodule OnTheMap.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OnTheMap.Core` context.
  """

  import OnTheMap.Fixtures

  alias OnTheMap.Auth
  alias OnTheMap.Core

  @doc """
  Generate a bid.
  """
  def bid_fixture(attrs \\ default_bid_attrs()) do
    {:ok, bidder} = Auth.create_identity(generate_random_identity())

    {:ok, bid} =
      attrs
      |> Enum.into(%{
        value: 42,
        bidder_id: bidder.id
      })
      |> Core.create_bid()

    bid
  end

  def default_bid_attrs() do
    item = item_fixture()
    {:ok, bidder} = Auth.create_identity(generate_random_identity())

    %{item_id: item.id, bidder_id: bidder.id}
  end

  @default_item_attrs %{
    t0: ~N[2022-12-13 07:41:00],
    t1: ~N[2022-12-13 07:41:00]
  }

  def item_fixture(attrs \\ @default_item_attrs) do
    now = NaiveDateTime.utc_now()

    {:ok, item} =
      attrs
      |> Enum.into(%{
        t0: now,
        t1: NaiveDateTime.add(now, 86_000)
      })
      |> Core.create_item()

    item
  end
end
