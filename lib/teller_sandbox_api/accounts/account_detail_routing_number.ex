defmodule TellerSandboxApi.Accounts.AccountDetailRoutingNumber do
  use Ecto.Schema
  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
      field(:ach, :string)
  end
end
