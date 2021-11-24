defmodule TellerSandboxApi.Transactions.Transaction do
  use Ecto.Schema
  @derive Jason.Encoder
  @min_transaction_cost_in_pennies 123
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



  def generate_transactions_from_account(account = %TellerSandboxApi.Accounts.AccountBalance{}) do
    hash = Murmur.hash_x86_32(account)
    today = date().utc_today()
    the_past = Date.add(today, -89)

    balance_in_pennies = account.available
      |> Decimal.mult(Decimal.new("100"))
      |> Decimal.to_integer()

    total_spend_transactions =
      Integer.mod(Murmur.hash_x86_32(account.available), balance_in_pennies)
      |> Decimal.new()
      |> Decimal.div(Decimal.new("100"))


    {_, transactions} =
      Date.range(the_past, today)
      |> Enum.reduce({total_spend_transactions, []}, fn date, {balance, transactions} ->
        transactions_left = 90 - length(transactions)
        amount = amount(balance, transactions_left)
        running_balance = Decimal.sub(balance, amount)
        id = "test_txn_" <> Base.encode32("#{Murmur.hash_x86_32(date)}")
        description = Enum.at(merchants(), Integer.mod(hash, length(merchants())))
        merchant_replace_signs = String.replace(description, ~r"[:_!@#$%^&*':|,./]", "")
        merchant_upcase = String.upcase(merchant_replace_signs)
        transaction = %__MODULE__
        {
          account_id: account.account_id,
          amount: Decimal.negate(amount),
          date: date,
          description: description,
          details: %TellerSandboxApi.Transactions.TransactionDetail{
            category: Enum.at(merchant_categories(), Integer.mod(hash, length(merchant_categories()))),
            counterparty: %TellerSandboxApi.Transactions.TransactionDetailCounterparty{
              name: merchant_upcase,
              type: Enum.at(counterparty_type(), Integer.mod(hash, length(counterparty_type()))),
            },
            processing_status: "complete",
          },
          status: "posted",
          id: id,
          links: %TellerSandboxApi.Transactions.TransactionLink{
            account: "http://localhost:4000/accounts/#{account.account_id}",
            self: "http://localhost:4000/accounts/#{account.account_id}/transactions/#{id}"
          },
          running_balance: Decimal.add(balance, account.available),
          type: "card_payment"
        }
        {running_balance, [transaction | transactions]}
      end)
      transactions
  end

  defp amount(balance, 1), do: balance

  defp amount(balance, transactions_left) do
    hundred = Decimal.new("100")
    balance_in_pennies = balance |> Decimal.mult(Decimal.new("100")) |> Decimal.to_integer()
    max_transaction_cost_in_pennies =
      (balance_in_pennies - transactions_left * @min_transaction_cost_in_pennies) /
        transactions_left

    Murmur.hash_x86_32(balance_in_pennies)
    |> Integer.mod(round(max_transaction_cost_in_pennies))
    |> Decimal.div(hundred)
  end

  defp date(), do: Application.fetch_env!(:teller_sandbox_api, :date_module)

  def get_by_id(token, account_id, transaction_id) do
    with account = %{} <- TellerSandboxApi.Accounts.AccountBalance.get_by_id(token, account_id),
         transactions = [_ | _] <- generate_transactions_from_account(account) do
      Enum.find(transactions, &(&1.id == transaction_id))
    end
  end

  def counterparty_type() do
    [
      "human",
      "organization"
    ]
  end

  defp merchants() do
    [
      "Uber",
      "Uber Eats",
      "Lyft",
      "Five Guys",
      "In-N-Out Burger",
      "Chick-Fil-A",
      "AMC Metreon",
      "Apple",
      "Amazon",
      "Walmart",
      "Target",
      "Hotel Tonight",
      "Misson Ceviche",
      "The Creamery",
      "Caltrain",
      "Wingstop",
      "Slim Chickens",
      "CVS",
      "Duane Reade",
      "Walgreens",
      "Rooster & Rice",
      "McDonald's",
      "Burger King",
      "KFC",
      "Popeye's",
      "Shake Shack",
      "Lowe's",
      "The Home Depot",
      "Costco",
      "Kroger",
      "iTunes",
      "Spotify",
      "Best Buy",
      "TJ Maxx",
      "Aldi",
      "Dollar General",
      "Macy's",
      "H.E. Butt",
      "Dollar Tree",
      "Verizon Wireless",
      "Sprint PCS",
      "T-Mobile",
      "Kohl's",
      "Starbucks",
      "7-Eleven",
      "AT&T Wireless",
      "Rite Aid",
      "Nordstrom",
      "Ross",
      "Gap",
      "Bed, Bath & Beyond",
      "J.C. Penney",
      "Subway",
      "O'Reilly",
      "Wendy's",
      "Dunkin' Donuts",
      "Petsmart",
      "Dick's Sporting Goods",
      "Sears",
      "Staples",
      "Domino's Pizza",
      "Pizza Hut",
      "Papa John's",
      "IKEA",
      "Office Depot",
      "Foot Locker",
      "Lids",
      "GameStop",
      "Sephora",
      "MAC",
      "Panera",
      "Williams-Sonoma",
      "Saks Fifth Avenue",
      "Chipotle Mexican Grill",
      "Exxon Mobil",
      "Neiman Marcus",
      "Jack In The Box",
      "Sonic",
      "Shell"
    ]
  end

  defp merchant_categories() do
    [
      "accommodation",
      "advertising",
      "bar",
      "charity",
      "clothing",
      "dining",
      "education",
      "electronics",
      "entertainment",
      "fuel",
      "groceries",
      "health",
      "home",
      "income",
      "insurance",
      "investment",
      "loan",
      "office",
      "phone",
      "service",
      "shopping",
      "software",
      "sport",
      "tax",
      "transport",
      "transportation",
      "utilities"
    ]
  end
end
