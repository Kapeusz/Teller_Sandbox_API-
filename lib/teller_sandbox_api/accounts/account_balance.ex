defmodule TellerSandboxApi.Accounts.AccountBalance do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:ledger, :string)
    field(:available, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountBalanceLink)
  end
end
