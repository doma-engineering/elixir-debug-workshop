defmodule DayOne.HTTPDemo do
  @moduledoc """
  A wrapper around :gen_tcp / :http_bin.
  """
  require Logger

  ## Use :gen_tcp to start a server that only accepts one connection before accepting the next.
  # {:ok, socket} = :gen_tcp.listen(port, active: false, reuseaddr: true, packet: :http_bin)
  ## Crash if the port reported by :inet.port is not the same as the port we passed in.
  # {:ok, ^port} = :inet.port(socket)
  # Logger.info("Listening on port #{port}")
  ## Use :gen_tcp.accept socket acceptor function to accept incoming connection
  ## See https://www.erlang.org/doc/man/gen_tcp.html
  # {:ok, ???} = :gen_tcp.accept(socket)
  # Logger.info("Accepted connection from #{inspect(???)}")
  ## Handle the request
  # ???
  # :timer.sleep(2500)
  # response = tau()
  ## Send the response
  # sent = :gen_tcp.send(???, simple_http(response))
  # Logger.debug("Sent #{sent} to #{inspect(???)}")
  ## Terminate the connection
  # :gen_tcp.???(???)
  # Logger.info("Handled connection from #{inspect(client)}")

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
