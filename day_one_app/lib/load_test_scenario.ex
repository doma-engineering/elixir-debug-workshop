defmodule LoadTestScenario do
  @moduledoc """
  A simplest Chaperon load test scenario.
  """

  use Chaperon.Scenario

  def init(session) do
    session |> assign(rate: 5, interval: seconds(5)) |> ok
  end

  def run(session) do
    session
    |> cc_spread(:root, round(session.assigned.rate), session.assigned.interval)
    |> await_all(:root)
  end

  def root(session) do
    session
    |> get("/")
  end
end
