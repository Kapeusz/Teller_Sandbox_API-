defmodule TellerSandboxApi.Accounts.AccountDetailRoutingNumber do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
      field(:ach, :string)
  end
end
