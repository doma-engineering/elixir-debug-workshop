defmodule OnTheMapWeb.Endpoint do
  @moduledoc """
  Basically an apache config.
  """

  use Phoenix.Endpoint, otp_app: :on_the_map

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  #
  # Read more about it in the docs for Plug.Session:
  # https://hexdocs.pm/plug/Plug.Session.html
  #
  # Perhaps, this is also relevant, since it has similar keys available for configuration:
  # https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-common-configuration
  @session_options [
    store: :cookie,
    key: "_on_the_map_key",
    signing_salt: "CHu/62Vk"
  ]

  # socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  # plug Plug.Static,
  #   at: "/",
  #   from: :on_the_map,
  #   gzip: false,
  #   only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :on_the_map
  end

  # Plug.RequestId is used to generate a unique request id.
  # Good for tracing requests.
  plug Plug.RequestId
  # Telemetry can be viewed at: /telemetry assuming you have the access.
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  # Parsers are used to decode the request body before it is processed.
  # We have the following parsers available:
  #  * :urlencoded -- parses form data (x-www-form-urlencoded)
  #  * :multipart -- parses multipart form data
  #  * :json -- parses JSON strings
  # We try to parse all the mime types in order of the list above.
  # We use Jason to decode the JSON strings.
  # The reason we use it instead of Poison is because other libraries we use use it too.
  # TODO: see if migrating to Poison is worth it.
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  # MethodOverride is a plug that allows you to override the HTTP method.
  # For example, you can make a request which we'll recognise as PUT by sending POST with a `_method=PUT` parameter.
  #
  # This is useful for clients that don't support PUT or DELETE requests.
  #
  # Read more: https://hexdocs.pm/plug/Plug.MethodOverride.html
  plug Plug.MethodOverride

  # Head is a plug that converts HEAD requests into GET requests.
  #
  # A HEAD request is normally used to check if a resource exists and to get its metadata.
  # It is identical to a GET request, except that the server MUST NOT return a message-body in the response.
  #
  # At the moment, I have no idea why would anyone want to use this plug, but here we are.
  #
  # Read more: https://hexdocs.pm/plug/Plug.Head.html
  plug Plug.Head

  # Session is a plug that manages the continuity of the session across requests.
  # In our case, we use @session_options to configure it.
  # Thus, the peristence of the session is handled by the cookie.
  # The session is signed, so its contents can be read but not tampered with.
  plug Plug.Session, @session_options

  # Finally, we plug in our router.
  # What a hustle.
  plug OnTheMapWeb.Router
end
