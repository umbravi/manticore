defmodule Manticore.Repo do
  use Ecto.Repo,
    otp_app: :manticore,
    adapter: Ecto.Adapters.Postgres
end
