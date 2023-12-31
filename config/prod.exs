import Config

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :arvore, Arvore.Repo,
  username: "pmoass73_arvore",
  password: "Arvore@123",
  database: "pmoass73_arvore",
  hostname: "192.185.213.48",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :arvore, Arvore.Web.Endpoint,
  # Expects url host and port to be configured in Endpoint.init callback
  load_from_system_env: true,
  url: [host: "https://teste-debora-arvore.fly.dev", port: 80]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :arvore, ArvoreWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :arvore, ArvoreWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
