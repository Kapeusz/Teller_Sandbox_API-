defmodule TellerSandboxApi.Accounts.AccountBalance do
  use Ecto.Schema
  @derive Jason.Encoder

  @link_prepend "http://localhost:4000/accounts/"
  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:ledger, :string)
    field(:available, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountBalanceLink)
  end

  # Based on the token passed from Account page we generate new balance information
  def from_token(token) do
    available = Decimal.new("20000")
    ledger = Decimal.new("22000")
    acc_id = "test_acc_" <> Base.encode32("#{token}")
    %__MODULE__{
      account_id: acc_id,
      ledger: ledger,
      available: available,
      links: %TellerSandboxApi.Accounts.AccountBalanceLink{
        self: @link_prepend <> "#{acc_id}/balances",
        account: @link_prepend <> "#{acc_id}",
      }
    }
  end

  # We get account details by the id of the account
  def get_by_id(token = "multiple_" <> _, account_id) do
    Enum.find(from_token(token), &(&1.account_id == account_id))
  end

  def get_by_id(token, account_id) do
    account = %{account_id: id} = from_token(token)

    if account_id == id do
      account
    end
  end

end
