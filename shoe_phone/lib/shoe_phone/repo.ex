defmodule ShoePhone.Repo do
  use Ecto.Repo,
    otp_app: :shoe_phone,
    adapter: Ecto.Adapters.Postgres
end
