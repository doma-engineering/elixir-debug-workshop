defmodule OnTheMapWeb.Plugs.CryptoVerifySignatureTest do
  @moduledoc """
  Testing the CryptoVerifySignature plug.
  """
  use OnTheMapWeb.ConnCase, async: true
  use Plug.Test

  alias OnTheMapWeb.Plugs.CryptoVerifySignature, as: VerifySignature
  alias OnTheMap.Crypto
  alias OnTheMap.Crypto.Eff, as: Eff
  alias OnTheMap.Crypto.Identity

  alias Uptight.Base, as: B

  setup %{conn: conn} do
    # Generate a keypair for the identity.
    # kp = Crypto.keypair_from_password("test keypair")
    {identity_params, secret} = generate_random_crypto_identity()
    {:ok, new_identity} = Eff.create_identity(identity_params)
    {:ok, identity} = Eff.generate_challenge(new_identity)

    # This is very important. It removes the woefully inadequate default of binary handling in Elixir.
    identity = Identity.tighten(identity)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> Phoenix.Controller.put_format("json")

    %{identity: identity, secret: secret |> B.raw_to_urlsafe!(), conn: conn}
  end

  test "that invalid headers halt the connection", %{conn: conn} do
    conn = conn |> put_id_header(<<255, 174>> |> B.raw_to_urlsafe!()) |> VerifySignature.call([])

    assert conn.status == 403
    assert conn.halted
  end

  test "that a valid id header with an invalid signature halt connection", %{identity: identity, conn: conn} do
    conn = conn |> put_id_header(identity.pk) |> put_signature_header("invalid") |> VerifySignature.call([])

    assert conn.status == 403
    assert conn.halted
  end

  test "that a valid id and signature headers don't halt the connection", %{
    identity: identity,
    conn: conn,
    secret: secret
  } do
    conn =
      conn
      |> put_id_header(identity.pk)
      |> put_signature_header(
        # TODO: This map may be a function in Uptight?
        Crypto.sign(
          identity.challenge,
          %{secret: secret, public: identity.pk}
        ).signature.encoded
      )
      |> VerifySignature.call([])

    assert is_nil(conn.status)
    refute conn.halted
  end

  test "that a valid id and signature headers generates a new challenge and updates the identity entry in the database",
       %{
         identity: identity,
         conn: conn,
         secret: secret
       } do
    conn
    |> put_id_header(identity.pk)
    # Now we cryptographically sign the challenge with the secret
    |> put_signature_header(
      Crypto.sign(
        identity.challenge,
        %{secret: secret, public: identity.pk}
      ).signature.encoded
    )
    |> VerifySignature.call([])

    updated_identity = OnTheMap.Repo.reload(identity)

    refute updated_identity.challenge === identity.challenge
  end

  defp put_id_header(conn, id), do: put_req_header(conn, VerifySignature.id_header(), id.encoded)
  defp put_signature_header(conn, signature), do: put_req_header(conn, VerifySignature.signature_header(), signature)
end
