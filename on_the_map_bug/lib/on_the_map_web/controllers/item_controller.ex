defmodule OnTheMapWeb.ItemController do
  use OnTheMapWeb, :controller

  alias OnTheMap.Core

  action_fallback OnTheMapWeb.FallbackController

  def index(conn, _params) do
    items = Core.list_items()
    render(conn, "index.json", items: items)
  end

  def show(conn, %{"id" => id}) do
    item = Core.get_item!(id)
    render(conn, "show.json", item: item)
  end
end
