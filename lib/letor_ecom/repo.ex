defmodule LetorEcom.Repo do
  use Ecto.Repo,
    otp_app: :letor_ecom,
    adapter: Ecto.Adapters.Postgres
end
