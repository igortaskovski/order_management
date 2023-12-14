# OrderManagement

To start the Phoenix app:

  * Run `mix setup` to install and setup dependencies
  * Run `mix ecto.setup` to setup the database and run migrations
  * Start the IEX console with `iex -S mix`
  * Run the commands below

# Usage

  ### Create an order

  `OrderManagement.Orders.create_order(%{email: "igor.taskovski@gmail.com", price: Money.new(49_99)})`
  ### Get an order by ID

  `OrderManagement.Orders.get_order(3)`
  ### Get an order for a customer by email

  `OrderManagement.Orders.get_orders_for_customer("igor.taskovski@gmail.com")`
  ### Apply a payment to an order and update the order balance

  `OrderManagement.Payments.apply_payment_to_order(%{amount: Money.new(29_99), order_id: 1})`
  ### Creates order and applies a full payment

  `OrderManagement.Orders.create_order_and_pay(%{email: "igor.taskovski@gmail.com", price: Money.new(79_99)})`

# Tests

  * Run the tests with `mix test`