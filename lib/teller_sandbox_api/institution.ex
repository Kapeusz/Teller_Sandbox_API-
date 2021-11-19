defmodule TellerSandboxApi.Institution do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
  end

  def from_token_hash(token_hash) do
    institutions = Enum.at(institutions, Integer.mod(token_hash, length(institutions)))

    %__MODULE__{
      id: institutions.id,
      name: institutions.name
    }
  end

  def institutions() do
    [
      %{id: "chase", name: "Chase"},
      %{id: "bank_of_america", name: "Bank of America"},
      %{id: "wells_fargo", name: "Wells Fargo"},
      %{id: "citibank", name: "Citibank"},
      %{id: "capital_one", name: "Capital One"}
    ]
  end
end
