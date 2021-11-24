defmodule TellerSandboxApiWeb.TransactionControllerTest do
  use TellerSandboxApiWeb.ConnCase, async: true
  import Mox

  describe "all" do
    test "incorrect params is a 404", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2020-11-01] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1:")}")
        |> get(Routes.transaction_path(conn, :all, "bad_param1"), %{"also" => "bad_param2"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "incorrect id is not found", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1:")}")
        |> get(Routes.transaction_path(conn, :all, "not_id"), %{"account_id" => "NOPE"})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "We can query for all of the transactions for a given account", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)

      response =
        build_conn()
        |> put_req_header("authorization","Basic #{Base.url_encode64("test_1234567890:")}")
        |> get(Routes.transaction_path(conn, :all, "test_acc_GEZDGNBVGY3TQOJQ"), %{"account_id" => "test_acc_GEZDGNBVGY3TQOJQ"})

      account = TellerSandboxApi.Accounts.AccountBalance.get_by_id("test_1234567890", "test_acc_GEZDGNBVGY3TQOJQ")

      decoded = Jason.decode!(response.resp_body)
      assert length(decoded) == 90
      assert response.resp_body == File.read!("test/support/fixtures/transactions.json")

      total_transaction_spend =
        Enum.reduce(decoded, Decimal.new(0), fn transaction, acc ->
          Decimal.new(transaction["amount"])
          |> Decimal.add(acc)
        end)
        |> Decimal.mult(-1)

      starting_balance = Decimal.new(List.last(decoded)["running_balance"])
      total_after_spend = Decimal.sub(starting_balance, total_transaction_spend)

      assert Decimal.compare(total_after_spend, account.balances.available) == :eq
    end
  end

  describe "get" do
    test "bad params cause 404", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1:")}")
        |> get(Routes.transaction_path(conn, :get, "bad", "params"),
        %{
          "account_id" => "bad",
          "transaction_id" => "params"
        })

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "We get the transaction returned", %{conn: conn} do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)

      response =
        build_conn()
        |> put_req_header(
          "authorization",
          "Basic #{Base.url_encode64("test_1234567890:")}"
        )
        |> get(
          Routes.transaction_path(conn, :get, "test_acc_GEZDGNBVGY3TQOJQ", "test_txn_GI4TAMBRGEYDOMA="),
        %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ",
          "transaction_id" => "test_txn_GI4TAMBRGEYDOMA="
        })
        |> json_response(200)

      assert response ==           %{
        "account_id" => "test_acc_GEZDGNBVGY3TQOJQ",
        "amount" => "-699.52",
        "date" => "2021-11-24",
        "description" => "Walmart",
        "details" => %{
          "category" => "utilities",
          "counterparty" => %{
            "name" => "WALMART",
            "type" => "organization",
          },
          "processing_status" => "complete",
        },
        "status" => "posted",
        "id" => "test_txn_GI4TAMBRGEYDOMA=",
        "links" => %{
          "account" => "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR",
          "self" => "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR/transactions/test_txn_GI4TAMBRGEYDOMA="
        },
        "running_balance" => "20699.52",
        "type" => "card_payment"
      }

    end
  end
end
