import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :payments, Payments.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :payments, PaymentsWeb.Endpoint, secret_key_base: secret_key_base

stripe_secret_key =
  System.get_env("STRIPE_SECRET_KEY") ||
    raise """
    environment variable STRIPE_SECRET_KEY is missing.
    You can view yours at https://dashboard.stripe.com/apikeys
    """

stripe_public_key =
  System.get_env("STRIPE_PUBLIC_KEY") ||
    raise """
    environment variable STRIPE_PUBLIC_KEY is missing.
    You can view yours at https://dashboard.stripe.com/apikeys
    """

config :stripity_stripe,
  api_key: stripe_secret_key,
  public_key: stripe_public_key
