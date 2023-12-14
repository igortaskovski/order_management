defmodule OrderManagement.Repo do
  use Ecto.Repo,
    otp_app: :order_management,
    adapter: Ecto.Adapters.Postgres
end
