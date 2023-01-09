defmodule DayOne.HTTP do
  @moduledoc """
  A wrapper around :gen_tcp / :http_bin.
  """
  require Logger

  # Use :gen_tcp to start a server that only accepts one connection before accepting the next.
  def accept(port \\ 8599) do
    {:ok, socket} = :gen_tcp.listen(port, active: false, reuseaddr: true, packet: :http_bin)

    accept(socket, port)
  end

  def accept(socket, port) do
    # Crash if the port reported by :inet.port is not the same as the port we passed in.
    {:ok, ^port} = :inet.port(socket)
    Logger.info("Listening on port #{port}")
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Accepted connection from #{inspect(client)}")
    # Handle the request
    handle_request(client)
    Logger.info("Handled connection from #{inspect(client)}")
    accept(socket, port)
  end

  # Handles request of the client.
  def handle_request(client) do
    # Read the request
    {:ok, request} = :gen_tcp.recv(client, 0)
    # Parse the request
    _request = parse_request(request)
    # Handle the request
    :timer.sleep(2500)
    response = tau()
    # Send the response
    sent = :gen_tcp.send(client, simple_http(response))
    Logger.debug("Sent #{sent} to #{inspect(client)}")
    :gen_tcp.shutdown(client, :write)
  end

  def parse_request(request) do
    Logger.info("Parsing request: #{inspect(request)}")
    request
  end

  # Get current UTC DateTime and return it as a string.
  def tau() do
    DateTime.utc_now()
    |> DateTime.to_string()
  end

  def simple_http(body) do
    """
    HTTP/1.1 200\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end
end
