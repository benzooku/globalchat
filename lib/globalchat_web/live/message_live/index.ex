defmodule GlobalchatWeb.MessageLive.Index do
  use GlobalchatWeb, :live_view

  alias Globalchat.Chat

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Globalchat.PubSub, "chat:main")
    end

    {:ok,
     socket
     |> assign(content: "")
     |> assign(username: "")
     |> stream(:messages, list_messages())}
  end

  @impl true
  def handle_event("send", %{"content" => content, "username" => username}, socket) do
    message = %{user: username, content: content}

    case Chat.create_message(message) do
      {:ok, message} ->
        Phoenix.PubSub.broadcast(Globalchat.PubSub, "chat:main", {:new_msg, message})

        {:noreply,
         socket
         |> stream_insert(:messages, message, at: 0)
         |> assign(content: "")}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("content_update", %{"content" => content}, socket) do
    {:noreply, assign(socket, content: content)}
  end

  @impl true
  def handle_event("username_update", %{"username" => username}, socket) do
    {:noreply, assign(socket, username: username)}
  end

  @impl true
  def handle_info({:new_msg, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end

  defp list_messages() do
    Chat.list_messages()
  end
end
