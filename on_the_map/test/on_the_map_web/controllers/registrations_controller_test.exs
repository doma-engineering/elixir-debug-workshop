defmodule OnTheMapWeb.IdentityControllerTest do
  use OnTheMapWeb.ConnCase

  alias OnTheMapWeb.Plugs.VerifySignature 

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "that create identity" do
    test "renders identity when data is valid", %{conn: conn} do
      conn = post(conn, Routes.registrations_path(conn, :create), generate_random_identity())
      assert %{"status" => 200} = json_response(conn, 200)

      {_k, challenge_binary} = Enum.find(conn.resp_headers, fn {k, _v} -> k == VerifySignature.challenge_header() end)
      {challenge, _} = Integer.parse(challenge_binary)

      assert challenge > 4
      assert challenge < 1024
    end

    test "renders errors when data is invalid", %{conn: conn} do
      secret = generate_random_identity()

      conn =
        conn
        |> post(Routes.registrations_path(conn, :create), secret)
        |> post(Routes.registrations_path(conn, :create), secret)

      assert %{"status" => 403, "errors" => errors} = json_response(conn, 403)
      assert %{"secret" => ["already taken"]} == errors
    end
  end
end
