# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OnTheMap.Repo.insert!(%OnTheMap.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
IO.inspect("Seeding the data")

alias OnTheMap.Repo
alias OnTheMap.Core.Item

# We insert just one item.
# Its t0 is 30 seconds from now,
# Its t1 is 1 minute from now.
Repo.insert!(%Item{
  t0: NaiveDateTime.add(NaiveDateTime.utc_now(), 30, :second),
  t1: NaiveDateTime.add(NaiveDateTime.utc_now(), 60, :second)
})
