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

# Configures Elixir's Logger.
# `metadata:` is a list of keys that will be included in the log message.
# for example, `metadata: [:request_id]` will include the request_id
# in the log message.
#
# `level:` is the minimum level of log messages that will be included.
# For example, `level: :debug` will include all log messages.
#
# `format:` is the format of the log message. The default format is:
# "$time $metadata[$level] $message
config :logger, backends: [{LoggerFileBackend, :file_debug}]

config :logger, :file_debug,
  path: "log/all.log",
  format: "$time $metadata[$level] $message\n",
  level: :debug,
  metadata: [:request_id]

config :logger, :console,
  level: :error,
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
