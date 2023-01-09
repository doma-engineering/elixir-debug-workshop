defmodule OnTheMapWeb.Plugs.VerifySignatureTest do
  @moduledoc """
  Testing the VerifySignature plug.
  """
  use OnTheMapWeb.ConnCase, async: true
  use Plug.Test

  alias OnTheMap.Auth
  alias OnTheMap.Auth.Identity
  alias OnTheMapWeb.Plugs.VerifySignature

  setup %{conn: conn} do
    {:ok, new_identity} = Auth.create_identity(generate_random_identity())
    {:ok, identity} = Auth.generate_challenge(new_identity)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> Phoenix.Controller.put_format("json")

    %{identity: identity, conn: conn}
  end

  test "with invalid headers halt conn", %{conn: conn} do
    conn = conn |> put_id_header("asdf") |> VerifySignature.call([])

    assert conn.status == 400
    assert conn.halted
  end

  test "with valid id header, but invalid signature - halt conn", %{identity: identity, conn: conn} do
    conn = conn |> put_id_header(Auth.id(identity)) |> put_signature_header("invalid") |> VerifySignature.call([])

    assert conn.status == 403
    assert conn.halted
  end

  test "with valid id and signature headers - do not halt the connection", %{identity: identity, conn: conn} do
    conn =
      conn
      |> put_id_header(Auth.id(identity))
      |> put_signature_header(String.at(identity.secret, identity.challenge))
      |> VerifySignature.call([])

    assert is_nil(conn.status)
    refute conn.halted
  end

  test "with valid id and signature headers - generates a new challenge and updates identity db column", %{
    identity: identity,
    conn: conn
  } do
    conn =
      conn
      |> put_id_header(Auth.id(identity))
      |> put_signature_header(String.at(identity.secret, identity.challenge))
      |> VerifySignature.call([])

    {_k, challenge} = Enum.find(conn.resp_headers, fn {k, _v} -> k == VerifySignature.challenge_header() end)
    %Identity{challenge: new_challenge} = OnTheMap.Repo.reload(identity)

    assert {^new_challenge, _} = Integer.parse(challenge)
    refute new_challenge === identity.challenge
  end

  defp put_id_header(conn, id), do: put_req_header(conn, VerifySignature.id_header(), id)
  defp put_signature_header(conn, signature), do: put_req_header(conn, VerifySignature.signature_header(), signature)
end
