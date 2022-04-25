defmodule LetorEcom.Transactions.UserWallet do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User

  schema "user_wallets" do
    field :amount, :decimal, read_after_writes: true, default: Decimal.new(0)
    field :wallet_id, :string, read_after_writes: true
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user_wallet, attrs) do
    user_wallet
    |> cast(attrs, [:amount, :wallet_id])
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(user_wallet, attrs) do
    user_wallet
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
