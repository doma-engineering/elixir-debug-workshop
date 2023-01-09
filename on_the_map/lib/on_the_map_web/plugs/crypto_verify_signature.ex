defmodule OnTheMapWeb.Plugs.CryptoVerifySignature do
  @moduledoc """
  A plug that you can integrate into your Phoenix pipeline to verify that the request is signed by the client.
  It can be inserted into a pipeline.
  It doesn't send on success, just makes a note that the signature is valid.
  """
  alias OnTheMap.Crypto
  alias OnTheMap.Crypto.Identity

  alias Uptight.Result
  alias Uptight.Base, as: B
  alias Uptight.Text, as: T

  import Uptight.Assertions

  import Plug.Conn
  # import Phoenix.Controller

  @auth_signature "x-nonsense-auth-sig"
  @auth_id "x-nonesense-auth-id"

  def init(_), do: nil

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _params) do
    case Result.new(fn ->
           {ok, identity} = find_identity(conn)
           assert match?({:ok, %Identity{}}, {ok, identity}), "Identity not found"
           assert verify_signature(identity, conn) |> Result.is_ok?(), "Signature is invalid"
           (Crypto.Eff.generate_challenge(identity) |> elem(1)).challenge
         end) do
      %Result.Ok{ok: challenge} ->
        assign(conn, :new_challenge, challenge)

      %Result.Err{err: err} ->
        send_resp(conn, 403, %{details: err} |> Jason.encode!()) |> halt()
    end
  end

  defp find_identity(conn) do
    with [id] when not is_nil(id) <- get_req_header(conn, @auth_id),
         %Identity{} = identity <- Crypto.Eff.get_identity_by_id(id |> T.new!()) do
      {:ok, identity}
    else
      _ -> {:error, 400}
    end
  end

  defp verify_signature(%Identity{} = identity, conn) do
    Result.new(fn ->
      signature = get_req_header(conn, @auth_signature) |> hd() |> B.mk_url()
      assert Result.is_ok?(signature)
      assert Crypto.Eff.is_valid_signature!(identity, signature.ok), "Signature is invalid"
    end)
  end

  def id_header, do: @auth_id

  def signature_header, do: @auth_signature
end
