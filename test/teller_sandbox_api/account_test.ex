defmodule TellerSandboxApi.AccountTest do
  use ExUnit.Case, async: true

  describe "from_token" do
    test "Returns an account for a given token" do
      assert %TellerSandboxApi.Accounts.Account{
      currency: "USD",
      enrollment_id: "enr_nmf3f7758gpc7b5cd6000",
      id: "test_acc_nmfff743stmo5n80t4000",
      institution: %TellerSandboxApi.Institution{id: "citibank", name: "Citibank"},
      last_four: "3836",
      links: %TellerSandboxApi.Accounts.AccountLink{
        balances: nil,
        details: nil,
        self: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV",
        transactions: "http://localhost/accounts/test_acc_GEZDGNBVGY3TQNRV/transactions",
      },
      name: "My Checking"
      subtype: "checking",
      type: "depository"
      }
    end

    test "the same token twice returns the same account" do
      token = "1234567865"
      account_1 = TellerSandboxApi.Accounts.Account.from_token(token)
      account_2 = TellerSandboxApi.Accounts.Account.from_token(token)

      assert account_1 == account_2
    end
  end
end
