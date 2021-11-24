defmodule TellerSandboxApiWeb.Controllers.TransactionController do
  use TellerSandboxApiWeb, :controller


  # Return all transactions for a given account id
  def all(conn, %{"account_id" => account_id}) do
    dashboard().increment_endpoint_count(:transactions)
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
  # Return transactions for a particular account id
  def get(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    dashboard().increment_endpoint_count(:transaction)
    case TellerSandboxApi.Transactions.Transaction.get_by_id(conn.assigns.token, account_id, transaction_id) do
      nil ->
        put_resp_content_type(conn, "application/json")
        |> Plug.Conn.send_resp(404, "Not Found")

      transaction = %{} ->
        conn |> put_resp_content_type("application/json") |> json(transaction)
    end
  end

  def get(conn, _), do: Plug.Conn.send_resp(conn, 404, "Not Found")
  defp dashboard(), do: Application.fetch_env!(:teller_sandbox_api, :dashboard_module)
end
