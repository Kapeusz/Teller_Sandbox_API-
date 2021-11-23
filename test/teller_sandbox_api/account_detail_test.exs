defmodule TellerSandboxApi.AccountDetailTest do
  use ExUnit.Case, async: true

  describe "from_token" do
    test "returns account details when for test_acc" do
      assert %TellerSandboxApi.Accounts.AccountDetail{
        account_id: "test_acc_nmfff743stmo5n80t4000",
        account_number: "12345769",
        links: %TellerSandboxApi.Accounts.AccountDetailLink{
          account: "htpp://localhost:4000/accounts/test_acc_nmfff743stmo5n80t4000",
          self: "htpp://localhost:4000/accounts/test_acc_nmfff743stmo5n80t4000/details"
        },
        routing_numbers: %TellerSandboxApi.Accounts.AccountDetailRoutingNumber{
           ach: "12345769"
        }
      }
    end
  end
end
