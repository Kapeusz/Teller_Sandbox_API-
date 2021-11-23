defmodule TellerSandboxApi.TransactionTest do
  use ExUnit.Case, async: true
  import Mox

  describe "generate_from_account_detail" do
    test " - generates the same accounts when generating the same account twice" do
      expect(DateMock, :utc_today, 2, fn -> ~D[2021-11-23] end)
      token = TellerSandboxApi.Accounts.AccountBalance.from_token("1234567865")
      transactions = TellerSandboxApi.Transactions.Transaction.generate_transactions_from_account(token)
      transactions_2 = TellerSandboxApi.Transactions.Transaction.generate_transactions_from_account(token)
      assert transactions == transactions_2
    end

    test " - when each id is different" do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)
      token = Account.from_token("1234567865")
      transactions = TellerSandboxApi.Transactions.Transaction.generate_transactions_from_account(token)
      uniq_ids = Enum.map(transactions, & &1.id) |> Enum.uniq()
      assert length(uniq_ids) == length(transactions)
    end

    test " - generates transactions for the last 90 days" do
      expect(DateMock, :utc_today, fn -> ~D[2021-11-23] end)
      token = Account.from_token("1234567865")
      transactions = TellerSandboxApi.Transactions.Transaction.generate_transactions_from_account(token)

      assert List.first(transactions).date == ~D[2021-11-23]
      last = List.last(transactions)
      assert last.date == Date.add(~D[2021-11-23], -89)

      uniq_dates = Enum.map(transactions, & &1.date) |> Enum.uniq()
      assert length(uniq_dates) == length(transactions)
    end
  end
end
