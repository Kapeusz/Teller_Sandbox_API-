defmodule TellerSandboxApiWeb.Router do
  use TellerSandboxApiWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TellerSandboxApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TellerSandboxApiWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TellerSandboxApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/accounts", Controllers.AccountController, :all
    get "/accounts/:account_id", Controllers.AccountController, :get
    get "/accounts/:account_id/details", Controllers.AccountController, :get_details
    get "/accounts/:account_id/balances", Controllers.AccountController, :get_balances
    get "/accounts/:account_id/transactions", Controllers.TransactionController, :all
    get "/accounts/:account_id/transactions/:transaction_id", Controllers.TransactionController, :get
    live "/dashboard", Live.DashboardLive , :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TellerSandboxApiWeb do
  #   pipe_through :api
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
