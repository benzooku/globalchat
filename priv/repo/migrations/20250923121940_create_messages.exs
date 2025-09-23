defmodule Globalchat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user, :string
      add :content, :string

      timestamps(type: :utc_datetime)
    end
  end
end
