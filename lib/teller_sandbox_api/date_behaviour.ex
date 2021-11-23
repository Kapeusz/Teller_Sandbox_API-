defmodule TellerSandboxApi.DateBehaviour do
  @callback utc_today() :: Date.t()
end
