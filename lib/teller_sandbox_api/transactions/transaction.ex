defmodule TellerSandboxApi.Transactions.Transaction do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:amount, :string)
    field(:date, :string)
    field(:description, :string)
    embeds_one(:details, TellerSandboxApi.Transactions.TransactionDetail)
    field(:status, :string)
    field(:id, :string)
    embeds_one(:links, TellerSandboxApi.Transactions.TransactionLink)
    field(:running_balance, :string)
    field(:type, :string)
  end
end
