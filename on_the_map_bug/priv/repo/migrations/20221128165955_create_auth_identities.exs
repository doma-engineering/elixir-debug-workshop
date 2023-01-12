defmodule OnTheMap.Repo.Migrations.CreateAuthIdentities do
  use Ecto.Migration

  def change do
    create table(:auth_identities) do
      add :url, :string, null: false
      add :secret, :text, null: false
      add :challenge, :integer

      timestamps()
    end

    create unique_index(:auth_identities, [:secret])
  end
end
