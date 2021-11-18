import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :teller_sandbox_api, TellerSandboxApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SR86PXwQCGAaiOAJdbHwplQQz9Tgz9uHE2xB02u5g4RVqM3QHuqIhwGPksGOowAN",
  server: false

# In test we don't send emails.
config :teller_sandbox_api, TellerSandboxApi.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
