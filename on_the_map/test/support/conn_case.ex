defmodule OnTheMapWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use OnTheMapWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias OnTheMap.Auth
  alias OnTheMapWeb.Plugs.VerifySignature

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import OnTheMapWeb.ConnCase
      import OnTheMap.Fixtures

      alias OnTheMapWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint OnTheMapWeb.Endpoint
    end
  end

  setup tags do
    OnTheMap.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers user, generates challenge and put valid headers to mimic valid registration / challenge processing logic.

      setup :register_and_put_challenge

  It stores an updated connection and a registered quiz_user in the
  test context.
  """
  def register_and_put_challenge(%{conn: conn}) do
    attrs = OnTheMap.Fixtures.generate_random_identity()
    {:ok, new_identity} = Auth.create_identity(attrs)
    {:ok, identity} = Auth.generate_challenge(new_identity)

    conn =
      conn
      |> put_id_header(Auth.id(identity))
      |> put_signature_header(String.at(identity.secret, identity.challenge))

    %{conn: conn, identity: identity}
  end

  defp put_id_header(conn, id), do: Plug.Conn.put_req_header(conn, VerifySignature.id_header(), id)

  defp put_signature_header(conn, signature),
    do: Plug.Conn.put_req_header(conn, VerifySignature.signature_header(), signature)
end
