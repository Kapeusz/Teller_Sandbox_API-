defmodule TellerSandboxApiWeb.Controllers.TransactionController do
  use TellerSandboxApiWeb, :controller

  # The transactions endpoint should return a list of transactions going back 90 days.
  # There should be 1 transaction per day.

  def all(conn, %{"account_id" => account_id}) do
    with account = %{} <- TellerSandboxApi.Accounts.AccountBalance.get_by_id(conn.assigns.token, account_id) do
      transactions = TellerSandboxApi.Transactions.Transaction.generate_transactions_from_account(account)

      conn
      |> put_resp_content_type("application/json")
      |> json(transactions)
    else
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")
    end
  end

  def all(conn, _), do: Plug.Conn.send_resp(conn, 404, "Not Found")

  def get(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    case TellerSandboxApi.Transactions.Transaction.get_by_id(conn.assigns.token, account_id, transaction_id) do
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")

      transaction = %{} ->
        conn |> put_resp_content_type("application/json") |> json(transaction)
    end
  end

  def get(conn, _), do: Plug.Conn.send_resp(conn, 404, "Not Found")
end
