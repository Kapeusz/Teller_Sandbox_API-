defmodule TellerSandboxApi.Transactions.TransactionDetail do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field(:processing_status, :string)
    field(:category, :string)
    embeds_one(:counterparty, TellerSandboxApi.Transactions.TransactionDetailCounterparty)
  end
end
