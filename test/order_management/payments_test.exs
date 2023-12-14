defmodule OrderManagement.PaymentsTest do
  use OrderManagement.DataCase

  alias OrderManagement.Payments

  describe "payments" do
    alias OrderManagement.Payments.Payment

    import OrderManagement.OrdersFixtures

    test "apply_payment_to_order/1 with valid data creates a payment" do
      order = order_fixture()

      valid_attrs = %{amount: Money.new(42), order_id: order.id}

      assert {:ok, %Payment{} = payment} = Payments.apply_payment_to_order(valid_attrs)
      assert payment.amount == Money.new(42)
    end

    test "apply_payment_to_order/1 with invalid order id returns an error" do
      invalid_attrs = %{amount: Money.new(1), order_id: 500}
      assert {:error, "Order not found"} = Payments.apply_payment_to_order(invalid_attrs)
    end

    test "apply_payment_to_order/1 with invalid amount returns an error" do
      invalid_attrs = %{amount: Money.new(0), order_id: 1}
      assert {:error, "Invalid amount"} = Payments.apply_payment_to_order(invalid_attrs)
    end

    test "payment amount exceeds the current balance due" do
      order = order_fixture()
      valid_attrs = %{amount: Money.new(500), order_id: order.id}
      assert {:error, "Payment amount exceeds the current balance due"} = Payments.apply_payment_to_order(valid_attrs)
    end
  end
end
