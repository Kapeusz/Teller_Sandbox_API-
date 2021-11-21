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

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    acc_id = "test_acc_" <> Base.encode32("#{token}")
    %__MODULE__{
      account_id: acc_id,
      ledger: "33648.09",
      available: "33803.48",
      links: %TellerSandboxApi.Accounts.AccountBalanceLink{
        self: @link_prepend <> "#{acc_id}/balances",
        account: @link_prepend <> "#{acc_id}",
      }
    }
  end
end
