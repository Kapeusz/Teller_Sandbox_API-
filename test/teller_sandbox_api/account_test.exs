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
        balances: "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQNRV/balances",
        details: "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQNRV/details",
        self: "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQNRV",
        transactions: "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQNRV/transactions",
      },
      name: "My Checking",
      subtype: "checking",
      type: "depository"
      }
    end

    test " - the same token twice returns the same account" do
      token = "1234567865"
      account_1 = TellerSandboxApi.Accounts.Account.from_token(token)
      account_2 = TellerSandboxApi.Accounts.Account.from_token(token)

      assert account_1 == account_2
    end

    test " - if _multiple token - produce multiple accounts" do
      [account_1, account_2] = TellerSandboxApi.Accounts.Account.from_token("multiple_3672394111")

      assert %TellerSandboxApi.Accounts.Account{
        currency: "USD",
        enrollment_id: "test_Mjg5MjAzNDM0Ng==",
        id: "test_acc_GI4DSMRQGM2DGNBW",
        institution: %TellerSandboxApi.Institution{id: "chase", name: "Chase"},
        last_four: "4346",
        links: %TellerSandboxApi.Accounts.AccountLink{
          balances: "http://localhost:4000/accounts/test_acc_GI4DSMRQGM2DGNBW/balances",
          details: "http://localhost:4000/accounts/test_acc_GI4DSMRQGM2DGNBW/details",
          self: "http://localhost:4000/accounts/test_acc_GI4DSMRQGM2DGNBW",
          transactions: "http://localhost:4000/accounts/test_acc_GI4DSMRQGM2DGNBW/transactions",
        },
        name: "My Checking",
        subtype: "checking",
        type: "depository"
      } = account_1

      assert %TellerSandboxApi.Accounts.Account{
        currency: "USD",
        enrollment_id: "test_MzY3MjM5NDExMQ==",
        id: "test_acc_GM3DOMRTHE2DCMJR",
        institution: %TellerSandboxApi.Institution{id: "bank_of_america", name: "Bank of America"},
        last_four: "4111",
        links: %TellerSandboxApi.Accounts.AccountLink{
          balances: "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR/balances",
          details: "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR/details",
          self: "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR",
          transactions: "http://localhost:4000/accounts/test_acc_GM3DOMRTHE2DCMJR/transactions",
        },
        name: "Ronald Reagan",
        subtype: "checking",
        type: "depository"
      } = account_2
    end

    test "repeated multiple token returns the same results" do
      [account_1, account_2] = TellerSandboxApi.Accounts.Account.from_token("multiple_3672394111")
      [account_a, account_b] = TellerSandboxApi.Accounts.Account.from_token("multiple_3672394111")

      assert account_1 == account_a
      assert account_2 == account_b
    end

    test "don't repeat institutions" do
      assert [one, two, three, four, five] = accounts = TellerSandboxApi.Accounts.Account.from_token("multiple_1")
      institutions = Enum.map(accounts, & &1.institution.id)

      assert one.institution.id not in (institutions -- [one.institution.id])
      assert two.institution.id not in (institutions -- [two.institution.id])
      assert three.institution.id not in (institutions -- [three.institution.id])
      assert four.institution.id not in (institutions -- [four.institution.id])
      assert five.institution.id not in (institutions -- [five.institution.id])
    end
  end
end
