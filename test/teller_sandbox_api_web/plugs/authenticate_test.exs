defmodule TellerSandboxApiWeb.AuthenticateTest do
  use TellerSandboxApiWeb.ConnCase, async: true

  test "a valid token works!", %{conn: conn} do
    connection =
      conn
      |> put_req_header("authorization", "Basic #{Base.url_encode64("test_thing:")}")
      |> TellerSandboxApiWeb.Plugs.Authenticate.call(%{})

    assert connection.assigns.token == "thing"
  end

  test "an invalid token does not works", %{conn: conn} do
    connection =
      conn
      |> put_req_header("authorization", "Basic #{Base.url_encode64("not a thing:")}")
      |> TellerSandboxApiWeb.Plugs.Authenticate.call(%{})

    assert connection.resp_body == "Unauthorized"
  end
end
