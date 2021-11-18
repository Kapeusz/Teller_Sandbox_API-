defmodule TellerSandboxApiWeb.PageController do
  use TellerSandboxApiWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 200, "Working...")
  end
end
