defmodule OnTheMapWeb.PhonyController do
  use OnTheMapWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.json", challenge: conn.assigns.new_challenge)
  end
end
