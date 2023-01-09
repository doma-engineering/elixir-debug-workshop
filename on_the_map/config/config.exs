# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :on_the_map,
  ecto_repos: [OnTheMap.Repo]

# Configures the endpoint
config :on_the_map, OnTheMapWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: OnTheMapWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: OnTheMap.PubSub,
  live_view: [signing_salt: "skGwEEye"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Check if "#{config_env()}.secret.exs" exists and import it if it does.
# This is useful for storing secrets in version control.
if File.exists?("config/#{config_env()}.secret.exs") do
  import_config "#{config_env()}.secret.exs"
end
