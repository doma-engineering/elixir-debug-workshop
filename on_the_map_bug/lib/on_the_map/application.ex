defmodule OnTheMap.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import DynHacks

  @impl true
  def start(_type, _args) do
    children = [
      OnTheMap.Repo,
      {Task.Supervisor, name: OnTheMap.TaskSupervisor},
      OnTheMapWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OnTheMap.Supervisor]

    Supervisor.start_link(children, opts)
    |> impure(fn _ ->
      Task.Supervisor.start_child(OnTheMap.TaskSupervisor, fn -> OnTheMap.Seed.run() end)
    end)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OnTheMapWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
