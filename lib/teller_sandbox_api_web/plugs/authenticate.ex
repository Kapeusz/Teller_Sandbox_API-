defmodule TellerSandboxApiWeb.Plugs.Authenticate do
  @moduledoc """
  A thin wrapper around the basic auth plug. The password field should be left empty. Validate the user token
  which should be in the username field.
  """
  import Plug.Conn

  def init(options), do: options

  @doc """
  Validates that the token is one that we recognize. The token will become the seed for random data generation so we may
  want to enforce it has sufficient entropy / length.
  https://hexdocs.pm/plug/Plug.BasicAuth.html
  """
  def call(conn, _opts) do
    with {"test_" <> user_name_token, _} <- Plug.BasicAuth.parse_basic_auth(conn),
         {:ok, _validate} <- validate_token(user_name_token) do
      assign(conn, :token, user_name_token)
    else
      _ -> Plug.BasicAuth.request_basic_auth(conn) |> halt()
    end
  end

  # Here we can validate the token.
  defp validate_token(_token) do
    {:ok, true}
  end
end
