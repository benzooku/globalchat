defmodule GlobalchatWeb.PageController do
  alias Globalchat.Repo
  alias Globalchat.Message
  use GlobalchatWeb, :controller
  import Ecto.Query

  def home(conn, _params) do
    query = from m in Message,
      order_by: [desc: m.inserted_at],
      limit: 20
    messages = Repo.all(query)
    conn
    |> render(:home, messages: messages)
  end
end
