defmodule TellerSandboxApi.Accounts.Account do
  use Ecto.Schema
  @link_prepend "http://localhost:4000/accounts/"
  @derive Jason.Encoder
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



  # The max number of accounts is the number of possible institutions because we can't repeat them.
  def from_token("multiple_" <> token) do
    # There cannot be more accounts with the same account_id
    # We need to ensure that when creating new account
    # that new account is not the same as the one that already exists

    # To do that we need to reduce over the data, so we can remove account names and institutions
    # as they are used. We also need to change the token slightly for each so we get different
    # results.
    institutions = TellerSandboxApi.Institution.institutions()
    number_of_accounts = Integer.mod(Murmur.hash_x86_32(token), length(institutions))
    initial_accumulator = {token, the_account_names(), institutions, []}

    {_, _, _, accounts} = 0..number_of_accounts
    |> Enum.reduce(initial_accumulator, fn _, {token, the_account_names, institutions, acc} ->
      token_hash = Murmur.hash_x86_32(token)
      id = "test_acc_" <> Base.encode32("#{token}")
      institution = Enum.at(institutions, Integer.mod(token_hash, length(institutions)))
      name = Enum.at(the_account_names, Integer.mod(token_hash, length(the_account_names)))
      acc_no_length = String.length(token)
      last_four = String.slice(token, (acc_no_length - 4)..-1)
      account = %__MODULE__{
        currency: "USD",
        enrollment_id: "test_" <> Base.encode64("#{token}"),
        id: id,
        institution: %TellerSandboxApi.Institution{id: institution.id, name: institution.name},
        last_four: last_four,
        links: %TellerSandboxApi.Accounts.AccountLink{
          balances: @link_prepend <> "#{id}/balances",
          details: @link_prepend <> "#{id}/details",
          self: @link_prepend <> "#{id}",
          transactions: @link_prepend <> "#{id}/transactions"
        },
        name: name,
        subtype: "checking",
        type: "depository"
        }

        {"#{token_hash}", the_account_names -- [name], institutions -- [institution], [account | acc]}
      end)
    accounts
  end

  def from_token(token) do
    token_hash = Murmur.hash_x86_32(token)
    id = "test_acc_" <> Base.encode32("#{token}")
    acc_no_length = String.length(token)
    last_four = String.slice(token, (acc_no_length - 4)..-1)
    %__MODULE__{
      currency: "USD",
      enrollment_id: "test_" <> Base.encode64("#{token}"),
      id: id,
      institution: TellerSandboxApi.Institution.from_token_hash(token_hash),
      last_four: last_four,
      links: %TellerSandboxApi.Accounts.AccountLink{
        balances: @link_prepend <> "#{id}/balances",
        details: @link_prepend <> "#{id}/details",
        self: @link_prepend <> "#{id}",
        transactions: @link_prepend <> "#{id}/transactions"
      },
      name: Enum.at(the_account_names(), Integer.mod(token_hash, length(the_account_names()))),
      subtype: "checking",
      type: "depository"
    }
  end

  # Returns the account with the given id if exists / return null if do not exist
  def get_by_id(token = "multiple_" <> _, account_id) do
    Enum.find(from_token(token), &(&1.id == account_id))
  end

  def get_by_id(token, account_id) do
    account = %{id: id} = from_token(token)

    if account_id == id do
      account
    end
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
