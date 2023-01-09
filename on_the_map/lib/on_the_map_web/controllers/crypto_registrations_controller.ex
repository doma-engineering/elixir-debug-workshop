defmodule OnTheMapWeb.CryptoRegistrationsController do
  use OnTheMapWeb, :controller

  alias OnTheMap.Crypto.Eff, as: Auth
  alias OnTheMap.Crypto.Identity

  action_fallback OnTheMapWeb.FallbackController

  @spec create(
          Plug.Conn.t(),
          map()
        ) :: Plug.Conn.t()
  def create(conn, identity_params) do
    with {:ok, %Identity{} = identity} <- Auth.create_identity(identity_params),
         {:ok, %Identity{challenge: challenge}} <- Auth.generate_challenge(identity) do
      conn
      |> put_status(200)
      |> render("success.json", challenge: challenge)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(403)
        |> put_view(OnTheMapWeb.ChangesetView)
        |> render("error.json", %{changeset: changeset, status: 403})
    end
  end
end
