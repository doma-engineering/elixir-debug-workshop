defmodule OnTheMapWeb.RegistrationsController do
  use OnTheMapWeb, :controller

  alias OnTheMap.Auth
  alias OnTheMap.Auth.Identity
  alias OnTheMapWeb.Plugs.VerifySignature

  action_fallback OnTheMapWeb.FallbackController

  @spec create(
          Plug.Conn.t(),
          map()
        ) :: Plug.Conn.t()
  def create(conn, identity_params) do
    with {:ok, %Identity{} = identity} <- Auth.create_identity(identity_params),
         {:ok, %Identity{challenge: challenge}} <- Auth.generate_challenge(identity) do
      conn
      |> put_resp_header(VerifySignature.challenge_header(), Integer.to_string(challenge))
      |> put_status(200)
      |> json(%{status: 200})
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(403)
        |> put_view(OnTheMapWeb.ChangesetView)
        |> render("error.json", %{changeset: changeset, status: 403})
    end
  end
end
