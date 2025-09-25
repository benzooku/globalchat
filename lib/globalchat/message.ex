defmodule Globalchat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :user, :string, default: "Anonymous"
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user, :content])
    |> validate_required([:user, :content])
    |> validate_length(:user, min: 2)
    |> validate_length(:user, max: 255)
    |> validate_length(:content, min: 2)
    |> validate_length(:content, max: 255)
  end
end
