defmodule Globalchat.Repo do
  use Ecto.Repo,
    otp_app: :globalchat,
    adapter: Ecto.Adapters.Postgres
end
