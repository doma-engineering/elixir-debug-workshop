if Mix.env() == :dev do
  defmodule LoadTest do
    @moduledoc """
    A simplest Chaperon load test, configured to work with the DayOneApp.
    """

    use Chaperon.LoadTest

    def default_config do
      %{base_url: "http://localhost:8599", http: %{}, scenario_timeout: 20_000}
    end

    def scenarios do
      [{LoadTestScenario, default_config()}]
    end
  end
end
