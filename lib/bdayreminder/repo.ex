defmodule Bdayreminder.Repo do
  use Ecto.Repo,
    otp_app: :bdayreminder,
    adapter: Ecto.Adapters.Postgres
end
