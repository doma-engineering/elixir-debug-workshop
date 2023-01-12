defmodule OnTheMapWeb.Plugs.VerifySignature do
  @moduledoc """
  Plug to verify the signature of a request.
  It can be inserted into a pipeline.
  It doesn't send on success, just makes a note that the signature is valid.
  """
  alias OnTheMap.Auth
  alias OnTheMap.Auth.Identity

  import Plug.Conn
  import Phoenix.Controller

  @auth_signature "x-nonsense-auth-sig"
  @auth_id "x-nonesense-auth-id"
  @auth_challenge "x-nonsense-auth-chal"

  def init(_), do: nil

  def call(conn, _params) do
    with {:ok, %Identity{} = identity} <- find_identity(conn),
         :ok <- verify_signature(identity, conn) do
      {:ok, %Identity{challenge: challenge} = current_identity} = Auth.generate_challenge(identity)
      challenge = Integer.to_string(challenge)

      conn |> assign(:current_identity, current_identity) |> put_resp_header(@auth_challenge, challenge)
    else
      {:error, status} when is_integer(status) ->
        conn
        |> put_status(status)
        |> put_view(OnTheMapWeb.ErrorView)
        |> render("generic.json", status: status)
        |> halt()
    end
  end

  defp find_identity(conn) do
    with [id] when not is_nil(id) <- get_req_header(conn, @auth_id),
         %Identity{} = identity <- Auth.get_identity_by_id(id) do
      {:ok, identity}
    else
      _ -> {:error, 400}
    end
  end

  defp verify_signature(%Identity{} = identity, conn) do
    with [signature] when not is_nil(signature) <- get_req_header(conn, @auth_signature),
         true <- Auth.valid_signature?(identity, signature) do
      :ok
    else
      _ -> {:error, 403}
    end
  end

  def id_header, do: @auth_id

  def signature_header, do: @auth_signature

  def challenge_header, do: @auth_challenge
end
