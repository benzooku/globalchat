defmodule GlobalchatWeb.PageController do
  use GlobalchatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
