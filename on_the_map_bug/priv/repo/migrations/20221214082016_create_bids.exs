defmodule OnTheMap.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :value, :integer
      add :item_id, references(:items, on_delete: :restrict)
      add :bidder_id, references(:auth_identities, on_delete: :restrict)

      timestamps()
    end

    create index(:bids, [:item_id])
    create index(:bids, [:bidder_id])
  end
end
