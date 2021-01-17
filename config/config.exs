# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nfl,
  ecto_repos: [Nfl.Repo]

# Configures the endpoint
config :nfl, NflWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iY+v8lIUKDC39U/lD6NoPXxeGinXte0hzfQX+9w+97ys98+gD6na6fZBlDzHxA2D",
  render_errors: [view: NflWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nfl.PubSub,
  live_view: [signing_salt: "zQIIx3wh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
