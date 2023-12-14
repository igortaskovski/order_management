defmodule OrderManagement.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount, Money.Ecto.Amount.Type
    field :order_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:order_id, :amount])
    |> validate_required([:order_id, :amount])
  end
end
