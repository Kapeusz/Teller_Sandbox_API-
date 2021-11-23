defmodule TellerSandboxApi.AccountBalanceTest do
  use ExUnit.Case, async: true

  describe "from_token" do
    test "returns account balance for test_acc" do
      assert %TellerSandboxApi.Accounts.AccountBalance{
        account_id: "test_acc_nmfff743stmo5n80t4000",
        ledger: "20000",
        available: "22000",
        links: %TellerSandboxApi.Accounts.AccountBalanceLink{
          self: "http://localhost:4000/accounts/test_acc_nmfff743stmo5n80t4000/balances",
          account: "http://localhost:4000/accounts/test_acc_nmfff743stmo5n80t4000",
        }
      }
    end
  end
end
