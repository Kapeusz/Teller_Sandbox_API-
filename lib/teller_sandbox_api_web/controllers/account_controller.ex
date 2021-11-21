defmodule TellerSandboxApiWeb.Controllers.AccountController do
  use TellerSandboxApiWeb, :controller

  # Your application may return one or more accounts for a given API token.


  # Given the same API token your server returns the same data each time a request is made,
  # meaning the same account(s) with exactly the same account information, and exactly the same feed of transactions,
  # even after application restarts.

  def all(conn, _) do
    accounts = TellerSandboxApi.Accounts.Account.from_token(conn.assigns.token)

    conn
    |> put_resp_content_type("application/json")
    |> json(accounts)
  end

  def get(conn, %{"account_id" => account_id}) do
    case TellerSandboxApi.Accounts.Account.from_token(conn.assigns.token) do
      accounts = [_ | _] ->
        account = Enum.find(accounts, &(&1.id == account_id))

        if account do
          conn |> put_resp_content_type("application/json") |> json(account)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end

      account = %{id: id} ->
        if id == account_id do
          conn |> put_resp_content_type("application/json") |> json(account)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end
    end
  end

  def get_details(conn, %{"account_id" => account_id}) do
    case TellerSandboxApi.Accounts.AccountDetail.from_id_and_token(conn.assigns.token) do
      details = [_ | _] ->
        detail = Enum.find(details, &(&1.id == account_id))

        if detail do
          conn |> put_resp_content_type("application/json") |> json(detail)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end

      detail = %{account_id: id} ->
        if id == account_id do
          conn |> put_resp_content_type("application/json") |> json(detail)
        else
          put_resp_content_type(conn, "application/json")
          |> Plug.Conn.send_resp(404, "Not Found")
        end
    end
  end
end
