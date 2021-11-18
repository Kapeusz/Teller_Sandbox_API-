defmodule TellerSandboxApi.Accounts.AccountBalanceLink do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:self, :string)
    field(:account, :string)
  end
end
