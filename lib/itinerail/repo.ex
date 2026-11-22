defmodule Itinerail.Repo do
  use Ecto.Repo,
    otp_app: :itinerail,
    adapter: Ecto.Adapters.Postgres
end
