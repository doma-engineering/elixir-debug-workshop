defmodule OnTheMap.Seed do
  @moduledoc """
  A very simple task that just inserts a new item into the database.
  Its t0 is set to 30 seconds from now, whereas its t1 is set to 1 minute from now.
  """

  require Logger

  alias OnTheMap.Repo
  alias OnTheMap.Core.Item

  @doc """
  The entry point for the task.
  NaiveDateTimes are truncated for insertion into PGSQL database.
  """
  def run() do
    Logger.info("Seeding the data!")

    Repo.insert!(%Item{
      t0:
        NaiveDateTime.truncate(NaiveDateTime.add(NaiveDateTime.utc_now(), 30, :second), :second),
      t1: NaiveDateTime.truncate(NaiveDateTime.add(NaiveDateTime.utc_now(), 60, :second), :second)
    })
  end
end
