defmodule GlobalchatWeb.MessageLive.Index do
  use GlobalchatWeb, :live_view

  alias Globalchat.Chat


  @impl true
  def mount(_params, _session, socket) do

    {:ok, 
      socket
      |> assign(content: "")
      |> stream(:messages, list_messages())

    }
  end 

  @impl true
  def handle_event("send", %{"content" => content}, socket) do
    case Chat.create_message(%{content: content}) do
      {:ok, message} ->
        {:noreply, 
          socket
          |> stream_insert(:messages, message, at: 0)
          |> assign(content: "")
        }
        

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("content_update", %{"content" => content}, socket) do
    {:noreply, assign(socket, content: content)}
  end

  defp list_messages() do
    Chat.list_messages()
  end
end
