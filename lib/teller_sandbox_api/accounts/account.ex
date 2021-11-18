defmodule TellerSandboxApi.Accounts.Account do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:currency_code, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    embeds_one(:institution, TellerSandboxApi.Institution)
    field(:last_four, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountLink)
    field(:name, :string)
    field(:subtype, :string)
    field(:type, :string)
  end
end
