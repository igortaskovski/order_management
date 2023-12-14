defmodule OrderManagement.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrderManagement.Payments` context.
  """

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount: 42
      })
      |> OrderManagement.Payments.apply_payment_to_order()

    payment
  end
end
