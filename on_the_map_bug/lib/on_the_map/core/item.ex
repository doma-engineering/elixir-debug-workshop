defmodule OnTheMap.Core.Item do
  @moduledoc """
  Represents auction item
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :t0, :naive_datetime
    field :t1, :naive_datetime

    has_many :bids, OnTheMap.Core.Bid

    field :top_bid, :integer, virtual: true
    field :bidder, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:t0, :t1])
    |> validate_required([:t0, :t1])
  end
end
