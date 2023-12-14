defmodule OrderManagement.OrdersTest do
  use OrderManagement.DataCase

  alias OrderManagement.Orders

  describe "orders" do
    alias OrderManagement.Orders.Order

    import OrderManagement.OrdersFixtures

    @invalid_attrs %{email: nil, price: nil, balance_due: nil}

    test "get_order/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{email: "some_email@mail.com", price: Money.new(42)}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.email == "some_email@mail.com"
      assert order.price == Money.new(42)
      assert order.balance_due == Money.new(42)
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "get_orders_for_customer/1 retrieves orders for a given customer email" do
      order_fixture()
      order_fixture()
      email = "some_email@mail.com"

      orders = Orders.get_orders_for_customer(email)
      assert length(orders) == 2

      # Verify that each order has the correct email
      assert Enum.all?(orders, &(&1.email == email))
    end

    test "create_order_and_pay/1 creates an order and applies a payment successfully" do
      valid_attrs = %{email: "some_email@mail.com", price: Money.new(42)}

      assert {:ok, %Order{} = order} = Orders.create_order_and_pay(valid_attrs)
      assert %Order{} = order
      order = Orders.get_order(order.id)
      assert order.balance_due == Money.new(0)
    end
  end
end
