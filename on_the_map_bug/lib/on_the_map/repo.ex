defmodule OnTheMap.Repo do
  use Ecto.Repo,
    otp_app: :on_the_map,
    adapter: Ecto.Adapters.Postgres
end
