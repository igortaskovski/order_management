defmodule OrderManagement.OrdersFixtures do
  alias OrderManagement.Repo
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrderManagement.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        balance_due: 42,
        email: "some_email@mail.com",
        price: Money.new(42)
      })
      |> OrderManagement.Orders.create_order()

    order =
      order
      |> Repo.preload(:payments)
    order
  end
end
