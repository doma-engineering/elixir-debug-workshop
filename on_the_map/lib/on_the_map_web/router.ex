defmodule OnTheMapWeb.Router do
  @moduledoc """
  The main router for OnTheMapWeb.
  """

  use OnTheMapWeb, :router

  alias OnTheMapWeb.Plugs.VerifySignature

  # Pipeline is a way to group plugs together and apply them to a scope.
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug VerifySignature
  end

  # "/api" is split into two scopes.
  # The first scope is for the registration controller.
  # The second scope is for the phony controller.
  # The first scope is not protected by the VerifySignature plug.
  scope "/api", OnTheMapWeb do
    pipe_through :api
    resources "/phony-register", RegistrationsController, only: [:create]
    resources "/register", CryptoRegistrationsController, only: [:create]
  end

  scope "/", OnTheMapWeb do
    pipe_through [:api, :protected]

    get "/items", ItemController, :index
    get "/item/:id", ItemController, :show
    post "/bid/:item_id", BidController, :create

    get "/phony", PhonyController, :index
  end
end
