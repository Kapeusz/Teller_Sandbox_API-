defmodule TellerSandboxApi.Accounts.AccountDetail do
  use Ecto.Schema

  @derive Jason.Encoder
  @link_prepend "localhost:4000/accounts/"
  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:account_number, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountDetailLink)
    embeds_one(:routing_numbers, TellerSandboxApi.Accounts.AccountDetailRoutingNumber)
  end

  def from_id_and_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    acc_id = "test_acc_" <> Base.encode32("#{token}")
    %__MODULE__{
      account_id: acc_id,
      account_number: String.to_integer(token),
      links: %TellerSandboxApi.Accounts.AccountDetailLink{
        account: @link_prepend <> "#{acc_id}",
        self: @link_prepend <> "#{acc_id}/details"
      },
      routing_numbers: %TellerSandboxApi.Accounts.AccountDetailRoutingNumber{
         ach: Murmur.hash_x86_32(token_hash)
      }
    }
  end
end
