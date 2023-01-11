defmodule ProjOne.HttpDemo do
  @moduledoc """
  A wrapper around :gen_tcp / :http_bin to demo Elixir basics.
  """

	require Logger

	def banana(port \\ 8599) do
    Logger.info("!! Starting banana !!")
    ## Use :gen_tcp to start a server that only accepts one connection before accepting the next.
    {:ok, socket} = :gen_tcp.listen(port, active: false, reuseaddr: true, packet: :http_bin)
    ## Crash if the port reported by :inet.port is not the same as the port we passed in.
    {:ok, ^port} = :inet.port(socket)
    Logger.info("Listening on port #{port}")
    # Task.async( fn -> loop_accept(socket) end)
    loop_accept(socket)
	end

  def loop_accept(socket) do
    ## Use :gen_tcp.accept socket acceptor function to accept incoming connection
    ## See https://www.erlang.org/doc/man/gen_tcp.html
    Logger.info("! Accepting at #{inspect socket} !")
    {:ok, client_socket} = :gen_tcp.accept(socket)
    Logger.info("Accepted connection from #{inspect(client_socket)}")
    Task.async( fn -> req_resp(client_socket) end)
    # Task.async( fn -> loop_accept(socket) end)
    loop_accept(socket)
  end

  def req_resp(client_socket) do
    ## Handle the request
    :timer.sleep(2500)
    response = tau() |> simple_http(200)
    ## Send the response
    sent = :gen_tcp.send(client_socket, response)
    Logger.debug("Sent #{sent} to #{inspect(client_socket)}")
    ## Terminate the connection
## vvv --- Probably this doesn't return!
    :gen_tcp.shutdown(client_socket, :read_write)
    IO.puts "Shut down read / write"
    Logger.info("Handled connection from #{inspect(client_socket)}")
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

  def simple_http(body, code) do
    """
    HTTP/1.1 #{code}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end

end
  # Tail call optimisation
  # f : < g (5) , h (42) >
  # f 0 : 1
  # f n : 1 + g ( n - 1)


