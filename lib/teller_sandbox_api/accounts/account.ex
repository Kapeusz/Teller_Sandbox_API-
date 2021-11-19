defmodule TellerSandboxApi.Accounts.Account do
  use Ecto.Schema
  @link_prepend "http://localhost/accounts/"

  @primary_key false
  embedded_schema do
    field(:currency, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    embeds_one(:institution, TellerSandboxApi.Institution)
    field(:last_four, :string)
    embeds_one(:links, TellerSandboxApi.Accounts.AccountLink)
    field(:name, :string)
    field(:subtype, :string)
    field(:type, :string)
  end

  @doc """
  Creates account/s based on the given token. The data that is generated is hashed off of the token - murmur package.
  Thus, there is no need to store any state in order to always get the same data returned for a given token.

  It does not guarantee that the each token returns unique data however, but it will be different
  enough in most cases to not matter.
  """

  def from_token("multiple_" <> token) do
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    id = "test_acc_" <> Base.encode32("#{token}")

    %__MODULE__{
    currency: "USD",
    enrollment_id: "test_" <> Base.encode64("#{token}"),
    id: id,
    institution: TellerSandboxApi.Institution.from_token_hash(token_hash),
    last_four: TellerSandboxApi.Accounts.AccountDetail.the_last_four(token_hash),
    links: %TellerSandboxApi.Accounts.AccountLink{
      balances: "http://localhost/accounts/#{id}/balances",
      details: "http://localhost/accounts/#{id}/details",
      self: "http://localhost/accounts/#{id}",
      transactions: "http://localhost/accounts/#{id}/transactions",
    },
    name: Enum.at(the_account_names(), Integer.mod(token_hash, length(the_account_names()))),
    subtype: "checking",
    type: "depository"
    }
  end

  defp the_account_names do
    [
      "My Checking",
      "Jimmy Carter",
      "Ronald Reagan",
      "George H. W. Bush",
      "Bill Clinton",
      "George W. Bush",
      "Barack Obama",
      "Donald Trump"
    ]
  end
end
