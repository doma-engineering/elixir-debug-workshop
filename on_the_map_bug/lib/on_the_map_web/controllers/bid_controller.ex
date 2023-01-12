defmodule OnTheMapWeb.BidController do
  use OnTheMapWeb, :controller

  alias OnTheMap.Core
  alias OnTheMap.Core.Bid
  alias OnTheMap.Core.Item

  action_fallback OnTheMapWeb.FallbackController

  def create(conn, %{"item_id" => item_id} = bid_params) do
    with %Item{} = item <- Core.get_item!(item_id),
         bid_params <- Map.merge(bid_params, %{"bidder_id" => conn.assigns.current_identity.id}),
         {:ok, %Bid{}} <- Core.create_bid(bid_params) do
      conn
      |> put_status(:created)
      |> render("create.json", top_bid: Core.top_bid(item))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(403)
        |> put_view(OnTheMapWeb.ChangesetView)
        |> render("error.json", %{changeset: changeset, status: 403})
      other_error ->
        other_error
    end
  end
end
