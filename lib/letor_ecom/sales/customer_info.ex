defmodule LetorEcom.Sales.CustomerInfo do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.Sales.Sale

  schema "customer_info" do
    field :name, :string
    field :phone, :string
    belongs_to(:user, User)
    belongs_to(:sale, Sale)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer_info, attrs) do
    customer_info
    |> cast(attrs, [:sale_id, :phone, :name])
    |> validate_required([:phone, :name])
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> assoc_constraint(:user)
    |> assoc_constraint(:sale)
    |> get_user_id_if_existing()
  end

  defp get_user_id_if_existing(changeset) do
    case changeset.valid? do
      true ->
        phone = get_field(changeset, :phone)

        user = Repo.get_by(User, phone: phone)

        case user do
          true -> changeset |> put_change(:user_id, user.id)
          _ -> changeset
        end

      _ ->
        changeset
    end
  end
end
