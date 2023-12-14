# Backend Coding Exercise

## Problem Description

For this exercise, we would like you to help us build out a simple order management system. Before building out any APIs
at the web layer, we would like to design and implement our business logic / context layer. This is where you come in.

## Expected Time & Effort

We don't want you to have to take too much time with this exercise and ask that you do not spend more than 4 hours.

If your resume suggests you have had experience using Elixir professionally, we would like your submission to also be in
Elixir. Otherwise you are free to use whatever programming language you are most comfortable with.

## Submission

Treat your code submission as if it was a new feature being submitted as a pull request for review by your new
teammates. You do not have to submit the exercise as a pull request, you can treat the project's README as the pull
request description.

## Requirements

### Functions

We need some functions that can provide the following behavior:

* `create_order` - It should be possible to create a new order without making an initial payment.

* `get_order` - It should be possible to fetch a previously created order given an order identifier. Details about any
  payments applied to the order should also be included as part of the order response.

* `get_orders_for_customer` - It should be possible to fetch a list of persisted orders matching a given customer
  email address.

* `apply_payment_to_order` - It should be possible to apply a payment to an existing order. It should be possible to
  call this function multiple times to make installment payments on an order; you should be able to create an order for
  $50, and then make a $10 payment, another $10 payment and then a $30 payment to fully pay down the order balance. This
  function should also be idempotent; if a client attempts to make the same payment twice, such as due to a network
  hiccup while making a request on poor connection, we do not want to apply the payment twice.

* `create_order_and_pay` - It should be possible to create a new order and apply a payment to that order that succeeds
  or fails as one operation. If applying the payment to the order fails, the order should not come back in the response
  for any of the `get_order*` function calls. Try incorporating a call similar to the following into your code,
  pretending that the function call is the result of making a call to a remote server not under your control:
  ```elixir
  defmodule GoblinPay do
    def capture_payment(_attrs) do
      # Fail about 25% of the time
      [:success, :success, :success, :failure] |> Enum.shuffle() |> hd()
    end
  end
  ```

### Models / Schemas

To satisfy the requirements of the API, the following is a minimum set of fields that must be included when returning
an order or a payment object. Work backwards from these fields to determine what you think are required inputs from the
consumer of the API.

You are free to include anything else you would like to support your design, or to give it a few personal touches.

Whenever an order is returned, it should include at least:
* some kind of identifier, such as an order ID
* the email address of the customer
* the original value of the order
* the current balance due on the order
* a list of payments applied to the order so far

Whenever an payment is returned, it should include at least:
* some kind of identifier, such as a payment ID
* the amount applied to the order

### Persistence

Using an on-disk data store such as a SQL database is not a requirement; you may choose to use any data store you can
think of, including ones that are in-memory or process-based. Provided the following two conditions are met, you will
not be evaluated on performance or the choice of technique, only that the code using it is still easily readable:

* State can be maintained across multiple calls to the above functions from within a REPL or test.

* The updated global state is not returned as part of the function's return value. For example, in Elixir you can pass
  the function a pid of a process that is maintaining state for a collection of orders, but you cannot pass that
  collection of orders directly to one of the functions or get the updated collection of orders back as part of the
  function's return value.

## Out of Scope

Anything at the web layer. In this context, "web layer" is referring any of the code needed take a web request and
convert it into something that calls one or more of the required functions above. It also refers to anything that takes
the function's return value and converts it to a web response payload or error message.

At Peek, we would normally define this web layer as a GraphQL schema with some lightweight resolvers and glue code that
calls into context functions at the business logic / context layer. Knowledge of GraphQL is not required to complete
this exercise. See [GraphQL APIs](#graphql-apis) at the end of gist.

You can assume that the web API that eventually gets built around your solution:

* Will not be exposed directly to the Internet; the only consumer of the API will be employees hired by the owner, using
  a custom POS (point-of-sale) app on a tablet. Employees will be both authenticated and authorized to have access to
  all of the functions being written.

* Will handle casting and basic validation that only has to look at that single value. For example, you can assume that
  fields you expect to be required always have a value, that booleans are not provided as numbers, and inputs that can
  be converted to another data type have already been converted (i.e. "2021-12-03" to a date).

## GraphQL APIs

![gql+peek](https://user-images.githubusercontent.com/221693/62170358-f89cfd80-b2df-11e9-9488-e913f1866613.png)

The engineers at Peek are big fans of GraphQL. We like the benefits it provides over a classical REST API, including the
strong typing, the flexibility for the client to request exactly what they need, and the automatic documentation it
provides. We also like having clear boundaries within our applications, separating the API from our business logic or
context layers.

We mention this here in the exercise because virtually all of our new web APIs are written in GraphQL. We also follow
similar patterns as this exercise throughout our codebase. If you are not yet familiar with GraphQL and have some extra
time in your day, we would recommend [getting a feel for it](https://graphql.org/learn/) and deciding whether you would
also enjoy working with it.

Please do not submit any GraphQL or other web APIs as part of your submission; you will not be evaluated on them. You
are, however, free to build out a GraphQL-based web layer on your own time if you are looking for something to apply
the learning materials toward.