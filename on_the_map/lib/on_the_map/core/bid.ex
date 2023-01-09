defmodule OnTheMap.Core.Bid do
  @moduledoc """
  Represent an auction bid for specific item by specific identity
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias OnTheMap.Auth.Identity
  alias OnTheMap.Core.Item

  schema "bids" do
    field :value, :integer

    belongs_to :item, Item
    belongs_to :bidder, Identity, foreign_key: :bidder_id

    timestamps()
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [:value, :bidder_id, :item_id])
    |> validate_required([:value, :item_id, :bidder_id])
  end
end
