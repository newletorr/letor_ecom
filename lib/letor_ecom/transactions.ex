defmodule LetorEcom.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Transactions.{Payment, UserWallet}

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Creates a payment.

  ## Examples

      iex> make_order_payment(%{field: value})

      {:ok, %Payment{}}

      iex> make_order_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def make_order_payment(attrs \\ %{}) do
    order = Repo.get(Order, attrs.order_id)
    user = Repo.get(User, attrs.user_id)

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

    new_attrs =
      Map.merge(attrs, %{
        reference_code: ref_code,
        authorization_url: auth_url,
        amount: order.grand_total,
        order_id: attrs.order_id,
        user_id: attrs.user_id
      })

    %Payment{}
    |> Payment.order_payment_changeset(new_attrs)
    |> Repo.insert()
  end

  def verify_order_payment(%Payment{} = payment) do
    [url, headers] = [
      "https://api.paystack.co/transaction/verify/#{payment.reference_code}",
      [
        Authorization: "Bearer #{System.get_env("PAYSTACK_KEY")}",
        Accept: "Application/json; Charset=utf-8"
      ]
    ]

    {:ok, response} = HTTPoison.get(url, headers)

    {:ok, res_body} = Poison.decode(response.body)

    verified =
      if res_body["data"]["status"] == "success" do
        true
      else
        false
      end

    transaction_id = res_body["data"]["id"]
    ip_address = res_body["data"]["ip_address"]

    payment
    |> Payment.payment_verification_changeset(%{
      verified: verified,
      transaction_id: transaction_id,
      ip_address: ip_address
    })
    |> Repo.update()
  end

  @doc """
  Creates a user_wallet.

  ## Examples

      iex> create_user_wallet(%{field: value})
      {:ok, %UserWallet{}}

      iex> create_user_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_wallet(attrs \\ %{}) do
    %UserWallet{}
    |> UserWallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_wallet.

  ## Examples

      iex> update_user_wallet(user_wallet, %{field: new_value})
      {:ok, %UserWallet{}}

      iex> update_user_wallet(user_wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_wallet(%UserWallet{} = user_wallet, attrs) do
    user_wallet
    |> UserWallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_wallet.

  ## Examples

      iex> delete_user_wallet(user_wallet)
      {:ok, %UserWallet{}}

      iex> delete_user_wallet(user_wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_wallet(%UserWallet{} = user_wallet) do
    Repo.delete(user_wallet)
  end
end
