defmodule Scout.Repo do
  use Ecto.Repo,
    otp_app: :scout,
    adapter: Ecto.Adapters.Postgres
end
