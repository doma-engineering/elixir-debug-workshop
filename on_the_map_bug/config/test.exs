import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :on_the_map, OnTheMap.Repo,
  password: "postgres",
  hostname: "localhost",
  database: "on_the_map_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5666,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :on_the_map, OnTheMapWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rpB5Mx7nLwHJI00S+deGdU13qBhOEw4sQAI9MAGC0dxiYu2r8djMAq5W/qvxsMib",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

import_config("test.non-secret.exs")

# Check if "#{config_env()}.secret.exs" exists and import it if it does.
# This is useful for storing secrets in version control.
if File.exists?("#{config_env()}.secret.exs") do
  IO.puts("Importing #{config_env()}.secret.exs")
  import_config "#{config_env()}.secret.exs"
end
