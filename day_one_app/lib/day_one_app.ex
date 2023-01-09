defmodule DayOneApp do
  @moduledoc """
  Application module for DayOneApp.
  See https://hexdocs.pm/elixir/Application.html for more information.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [{Task, fn -> DayOneApp.HTTP.accept() end}]

    # See https://hexdocs.pm/elixir/Supervisor.html
    opts = [strategy: :one_for_one, name: DayOneApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
