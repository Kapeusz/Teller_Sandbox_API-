defmodule TellerSandboxApi.Accounts.AccountDetail do
  use Ecto.Schema

  @derive Jason.Encoder
  @link_prepend "http://localhost:4000/accounts/"
  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:account_number, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountDetailLink)
    embeds_one(:routing_numbers, TellerSandboxApi.Accounts.AccountDetailRoutingNumber)
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    acc_id = "test_acc_" <> Base.encode32("#{token}")
    acc_no_length = String.length(token)
    acc_no = String.slice(token, (acc_no_length - 8)..-1)
    %__MODULE__{
      account_id: acc_id,
      account_number: acc_no,
      links: %TellerSandboxApi.Accounts.AccountDetailLink{
        account: @link_prepend <> "#{acc_id}",
        self: @link_prepend <> "#{acc_id}/details"
      },
      routing_numbers: %TellerSandboxApi.Accounts.AccountDetailRoutingNumber{
         ach: Murmur.hash_x86_32(token_hash)
      }
    }
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    acc_id = "multiple_" <> Base.encode32("#{token}")
    acc_no_length = String.length(token)
    acc_no = String.slice(token, (acc_no_length - 8)..-1)
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
