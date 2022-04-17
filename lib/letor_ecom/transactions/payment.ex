defmodule LetorEcom.Transactions.Payment do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.CustomerPurchases.Order

  schema "payments" do
    field :amount, :decimal, read_after_writes: true
    field :authorization_url, :string, read_after_writes: true
    field :ip_address, :string, read_after_writes: true
    field :reference_code, :string, read_after_writes: true
    field :transaction_id, :integer, read_after_writes: true
    field :verified, :boolean, default: false, read_after_writes: true
    belongs_to(:user, User)
    belongs_to(:order, Order)

    timestamps(type: :utc_datetime)
  end

  @spec order_payment_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def order_payment_changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :reference_code,
      :user_id,
      :order_id,
      :authorization_url,
      :amount
    ])
    |> assoc_constraint(:user)
    |> assoc_constraint(:order)
  end

  @spec payment_verification_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def payment_verification_changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :transaction_id,
      :reference_code,
      :verified,
      :ip_address
    ])
  end
end
