defmodule LetorEcom.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Transactions` context.
  """
  import LetorEcom.AccountFixtures
  import LetorEcom.CustomerPurchasesFixtures

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    order = order_fixture
    user = user_fixture

    [url, headers] = [
      "https://api.paystack.co/transaction/initialize",
      [
        Authorization: "Bearer #{System.get_env("PAYSTACK_KEY")}",
        Accept: "Application/json; Charset=utf-8"
      ]
    ]

    grand_total_to_string = Decimal.to_string(Decimal.mult(order.grand_total, 100))

    {:ok, body} =
      Poison.encode(%{
        email: user.email,
        amount: grand_total_to_string,
        custom_fields: [
          %{display_name: "Order ID", variable_name: "Order ID", value: order.id}
        ]
      })

    {:ok, response} = HTTPoison.post(url, body, headers)

    {:ok, res_body} = response.body |> Poison.decode()

    ref_code = res_body["data"]["reference"]

    auth_url = res_body["data"]["authorization_url"]

    {:ok, payment} =
      attrs
      |> Enum.into(%{
        reference_code: ref_code,
        authorization_url: auth_url,
        amount: order.grand_total,
        order_id: order.id,
        user_id: user.id
      })
      |> LetorEcom.Transactions.make_order_payment()

    payment
  end

  @doc """
  Generate a user_wallet.
  """
  def user_wallet_fixture(attrs \\ %{}) do
    {:ok, user_wallet} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        wallet_id: "some wallet_id"
      })
      |> LetorEcom.Transactions.create_user_wallet()

    user_wallet
  end
end
