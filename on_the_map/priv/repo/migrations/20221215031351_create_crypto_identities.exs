defmodule OnTheMap.Repo.Migrations.CreateCryptoIdentities do
  use Ecto.Migration

  def change do
    # schema "crypto_identities" do
    #   # Urlsafe base64 encoded public key
    #   field :pk, :string
    #   # FQDN of the user's website
    #   field :url, :string
    #   # Current challenge for the identity
    #   field :challenge, :string

    #   timestamps()
    # end

    create table(:crypto_identities) do
      add :pk, :string, null: false
      add :url, :string, null: false
      add :challenge, :string
      timestamps()
    end
  end
end
