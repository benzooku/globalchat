defmodule Globalchat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Globalchat.Chat` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        user: "some user"
      })
      |> Globalchat.Chat.create_message()

    message
  end
end
