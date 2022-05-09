defmodule LetorEcom.Account.Address do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User

  schema "addresses" do
    field :address1, :string, read_after_writes: true
    field :address2, :string, read_after_writes: true
    field :business_name, :string, read_after_writes: true
    field :order_instruction, :string, read_after_writes: true
    field :zip_code, :string, read_after_writes: true
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:user_id, :address1, :address2, :business_name, :order_instruction, :zip_code])
    |> validate_required([:user_id, :address1, :business_name, :zip_code])
    |> assoc_constraint(:user)
  end

  def deletion_changeset(address, attrs \\ %{}) do
    address
    |> assoc_constraint(:user)
  end
end
