defmodule TellerSandboxApi.Accounts.AccountDetail do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:account_number, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountDetailLink)
    embeds_one(:routing_numbers, TellerSandboxApi.Accounts.AccountDetailRoutingNumber)
  end
end
