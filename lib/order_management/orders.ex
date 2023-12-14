defmodule OrderManagement.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias OrderManagement.Repo
  alias OrderManagement.Payments
  alias OrderManagement.Orders.Order
  alias OrderManagement.Payments.Payment

  @doc """
  Gets a single order and a list of payments applied to it.

  Returns nil if the Order does not exist.

  ## Examples

    iex> get_order(123)
    %Order{}

    iex> get_order(456)
    nil

  """
  def get_order(id) do
    Repo.get(Order, id)
    |> Repo.preload(:payments)
  end

  @doc """
  Gets a list of orders that belong to a customer.

  Returns an empty list if the email does not exist.

  ## Examples

      iex> get_orders_for_customer("some email")
      [%Order{}, ...]

      iex> get_orders_for_customer("some other email that doesn't exist")
      []

  """
  def get_orders_for_customer(email) do
    Repo.all(from o in Order, where: o.email == ^email, preload: :payments)
  end

  @doc """
  Creates an order.

  ## Examples

    iex> create_order(%{field: value})
    {:ok, %Order{}}

    iex> create_order(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
      |> Order.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Creates an order and applies a payment to it.

  ## Examples

      iex> create_order_and_pay(%{field: value})
      {:ok, %Order{}}

      iex> create_order_and_pay(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      # 25% of the time, the payment capture fails
      iex> create_order_and_pay(%{field: value})
      {:error, "Payment capture failed."}

  """
  def create_order_and_pay(attrs \\ %{}) do
    Repo.transaction(fn ->
      order =
        %Order{}
        |> Order.changeset(attrs)
        |> Repo.insert()

      case order do
        {:ok, order} ->
          capture_payment_result = Payments.capture_payment()

          case capture_payment_result do
            :success ->
              payment_params = %{order_id: order.id, amount: order.price}
              %Payment{}
                |> Payment.changeset(payment_params)
                |> Repo.insert()
              # Update the order's balance_due to 0
              update_order_balance_due(order.id, 0)
              order

            _ ->
              # If capture fails, roll back the transaction
              Repo.rollback("Payment capture failed.")
          end

        {:error, changeset} ->
          # If order insertion fails, roll back the transaction
          Repo.rollback({:error, changeset})
      end
    end)
  end

  @doc """
  Updates the balance due on an order.

  ## Examples

      iex> update_order_balance_due(id, new_balance_due)
      {:ok, %Order{}}

      iex> update_order_balance_due(id, bad_balance_due)
      {:error, %Ecto.Changeset{}}

  """
  def update_order_balance_due(id, new_balance_due) do
    order =
      Order
      |> Repo.get(id)

    case order do
      nil ->
        {:error, "Order not found"}

      %Order{} = order ->
        order
        |> Order.changeset(%{balance_due: new_balance_due})
        |> Repo.update()

        order
    end
  end
end
