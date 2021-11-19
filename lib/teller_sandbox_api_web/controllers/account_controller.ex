defmodule TellerSandboxApiWeb.Controllers.AccountController do
  use TellerSandboxApiWeb, :controller

  # Your application may return one or more accounts for a given API token.


  # Given the same API token your server returns the same data each time a request is made,
  # meaning the same account(s) with exactly the same account information, and exactly the same feed of transactions,
  # even after application restarts.

  def get(conn, _) do
    conn.assigns
    |> IO.inspect(limit: :infinity, label: "")
  end
end
