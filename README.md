# TellerSandboxApi


### Implemented features
 - All necessary routes are working
 - User can get information about their account, account details, balance and transactions
 - User can get details about each transaction
 - User can get information about all their accounts
 - User can see information about request (accounts/transactions)


## Tech
- Elixir 1.12.3 (compiled with Erlang/OTP 24)

## How to start the application

<pre>
  git clone https://github.com/Kapeusz/Teller_Sandbox_API-.git
  cd teller_sandbox_api
  mix deps.get
  mix compile
  mix phx.server
 </pre>
  
  ## Making a request
  ### Authorization
  Username field needs to be filled with test_ and 10 numbers (random) after. Password must be left blank.
  #### Example for a user with one account: 
  Username: ```test_1234567890```
  
   #### Example for a user with multiple accounts
   Username: ```test_multiple_1234567890```
   
   ## Testing
   
   run ```mix test```
   
   
