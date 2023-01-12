defmodule OnTheMap.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :t0, :naive_datetime
      add :t1, :naive_datetime

      timestamps()
    end
  end
end
