defmodule TellerSandboxApi.Transactions.TransactionDetailCounterparty do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:type, :string)
  end
end
