defmodule Bidding do
  @moduledoc """
  Bid on items. Should work with OnTheMap.
  """
  use Chaperon.Scenario

  require Logger

  @bid_qty 90

  def init(session) do
    session
    # rate: incoming requests per interval
    # interval: spread request rate over this amount of time (in ms)
    |> assign(rate: 25, interval: seconds(1), items: [])
    |> ok
  end

  def run(session) do
    session
    |> register()
    |> get_items()
    |> repeat(:make_bid, @bid_qty)
  end

  def concurrent(session) do
    session
    |> cc_spread(
      :make_bid,
      round(session.assigned.rate),
      session.assigned.interval
    )
    |> await_all(:make_bid)
  end

  def make_bid(session) do
    item_id = Enum.random(session.assigned.items).id
    # item_id = 1
    value = Enum.random(100..1_000)

    session
    |> post("/bid/#{item_id}",
      headers: session.assigned.headers,
      json: [value: value],
      with_result: &sign_new_challenge/2
    )
  end

  def get_items(session) do
    session
    |> get("/items", headers: session.assigned.headers, with_result: &handle_items/2)
    |> IO.inspect()
  end

  def with_delay(session, delay) do
    put_in(session.config[:delay], delay)
  end

  def handle_items(session, %HTTPoison.Response{body: resp_body} = response) do
    items =
      resp_body
      |> Jason.decode!()
      |> Enum.map(fn item ->
        Map.merge(item, %{
          t0: parse_time_string(item["t0"]),
          t1: parse_time_string(item["t1"]),
          id: item["id"]
        })
      end)

    session
    |> update_assign(items: fn _existing_items -> items end)
    |> sign_new_challenge(response)
  end

  def register(session) do
    url = :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
    params = [url: "http://" <> url, secret: generate_secret()]

    session
    |> post("/api/phony-register", params: params, with_result: &handle_register(&1, params, &2))
  end

  def handle_register(session, params, %HTTPoison.Response{status_code: 200} = response) do
    <<id::binary-size(4)>> <> _rest = params[:secret]

    session = put_in(session.config[:id], id)
    session = put_in(session.config[:secret], params[:secret])

    sign_new_challenge(session, response)
  end

  def sign_new_challenge(session, %HTTPoison.Response{headers: headers}) do
    challenge = get_challege(headers)

    signed_challenge = String.at(session.config[:secret], challenge)

    headers = [
      {"x-nonesense-auth-id", session.config[:id]},
      {"x-nonsense-auth-sig", signed_challenge}
    ]

    assign(session, :headers, headers)
  end

  def sign_new_challenge(session, _error) do
    session
  end

  defp get_challege(headers) do
    {_h, challenge} = Enum.find(headers, fn {header, _} -> header == "x-nonsense-auth-chal" end)

    String.to_integer(challenge)
  end

  def generate_secret do
    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(1024)
    |> List.to_string()
  end

  @chars Enum.concat([?0..?9, ?A..?Z, ?a..?z])

  defp random_char_from_alphabet, do: Enum.random(@chars)

  defp parse_time_string(time) do
    {:ok, datetime} = NaiveDateTime.from_iso8601(time)

    datetime
  end
end

# defmodule Load.NaiveTest do
#   use Chaperon.LoadTest

#   def default_config do
#     %{
#       base_url: "http://localhost:4000"
#     }
#   end

#   def scenarios do
#     [
#       {{10, Load.NaiveScenario}, %{}},
#       {{20, Load.NaiveScenario}, %{}},
#       {{15, Load.NaiveScenario}, %{}}
#     ]
#   end
# end

# Chaperon.run_load_test(Load.NaiveTest, print_results: true)
