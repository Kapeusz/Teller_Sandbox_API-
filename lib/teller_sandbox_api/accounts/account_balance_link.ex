defmodule TellerSandboxApi.Accounts.AccountBalanceLink do
  use Ecto.Schema

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field(:self, :string)
    field(:account, :string)
  end
end
