defmodule ProjOneApp do
  @moduledoc """
  Start proj_one process tree!
  """

  use Application

  require Logger

  @impl true
  def start(start_type, start_arguments) do

    Logger.info("Starting #{__MODULE__} with #{inspect(start_type)} and #{inspect(start_arguments)}")

    Logger.remove_backend(:console)
# child_spec
# {Mod, args} -> Mod.child_spec(args) -> OTP-compat child
    children = [
      # Bad code! Rewrite to GenServer.
      {Task, &ProjOne.HttpDemo.banana/0}
    ]
    opts = [strategy: :one_for_one,
            name: ProjOneApp.Supervisor]
    Supervisor.start_link(children, opts)
    # By the way: spawn_link "gonzo" equivalent of OTP callback "start_link"
  end
end
