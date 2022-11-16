import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lens, LensWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "v6l1K9tGHXFOuSEPVrlMdQrfPVVYO4qNe6WjCc3v4B3akKtZBu895DvKv0ckUjmC",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
