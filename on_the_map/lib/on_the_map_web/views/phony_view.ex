defmodule OnTheMapWeb.PhonyView do
  use OnTheMapWeb, :view

  def render("index.json", %{challenge: challenge}) do
    %{status: 200, challenge: challenge}
  end
end
