# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :payments,
  ecto_repos: [Payments.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :payments, PaymentsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+Hm84RSXGgaRuoehkAJ+SU5JB1Fc/hP1kW0gBQueJ5JvgKaaFAWl3sDpCrgmF43e",
  render_errors: [view: PaymentsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Payments.PubSub,
  live_view: [signing_salt: "cs7bvIHa"]

config :payments, PaymentsWeb.Gettext, default_locale: "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
