defmodule OrderManagement.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :email, :string
    field :price, Money.Ecto.Amount.Type
    field :balance_due, Money.Ecto.Amount.Type

    timestamps(type: :utc_datetime)

    has_many :payments, OrderManagement.Payments.Payment
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:email, :price])
    |> validate_required([:email, :price])
    |> set_balance_due(attrs)
  end

  defp set_balance_due(changeset, attrs) do
    case {attrs[:price], attrs[:balance_due]} do
      {nil, balance_due} ->
        # If update_order_balance_due is called, price is nil and we use balance_due
        put_change(changeset, :balance_due, balance_due)

      {price, _} ->
        # Otherwise we are creating a new order, use price
        put_change(changeset, :balance_due, price)
    end
  end
end
