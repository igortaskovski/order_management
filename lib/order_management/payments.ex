defmodule OrderManagement.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias OrderManagement.Repo
  alias OrderManagement.Orders
  alias OrderManagement.Orders.Order
  alias OrderManagement.Payments.Payment

@doc """
  Applies a payment to an order and updates the order's balance.

  ## Examples

      iex> apply_payment_to_order(%{field: value})
      {:ok, %Payment{}}

      iex> apply_payment_to_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def apply_payment_to_order(attrs \\ %{}) do
    %{amount: amount, order_id: order_id} = attrs
    order = Orders.get_order(order_id)

    case Money.positive?(amount) do
      true ->

      case order do
        nil ->
          {:error, "Order not found"}

        %Order{} = _order ->
          new_balance_due = Money.subtract(order.balance_due, amount)
          if Money.negative?(new_balance_due) do
            {:error, "Payment amount exceeds the current balance due"}
          else
            # Create a new payment and associate it with the order
            payment_params = %{order_id: order_id, amount: amount}
            %Payment{}
              |> Payment.changeset(payment_params)
              |> Repo.insert()
              |> handle_payment(order_id, new_balance_due)
          end
      end

      false ->
        {:error, "Invalid amount"}
    end
  end

  @doc """
  Randomly returns success or failure to simulate 25% success rate in API call.

  ## Examples

      iex> capture_payment()
      :success

      iex> capture_payment()
      :failure

  """
  def capture_payment() do
    # Fail about 25% of the time
    [:success, :success, :success, :failure] |> Enum.shuffle() |> hd()
  end

  defp handle_payment({:ok, payment}, order_id, new_balance_due) do
    # Update the order's balance_due with the new value
    Orders.update_order_balance_due(order_id, new_balance_due)
    {:ok, payment}
  end

  defp handle_payment({:error, changeset}, _, _) do
    {:error, changeset}
  end
end
