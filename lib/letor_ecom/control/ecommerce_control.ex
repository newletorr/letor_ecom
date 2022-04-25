defmodule LetorEcom.Control.EcommerceControl do
  use LetorEcom.SchemaHelper
  alias LetorEcom.AgentsAndSuppliers.CampusAgent
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.{DeliveryCharge, ReferalDiscount}
  alias LetorEcom.Catalogue.ItemImage
  alias LetorEcom.HumanResource.StaffPosting

  schema "ecommerce_controls" do
    field :country, :string
    field :name, :string
    field :region, :string
    field :centre_code, :string
    has_many(:pickup_centres, PickupCentre)
    has_one(:delivery_charges, DeliveryCharge)
    has_one(:referal_discounts, ReferalDiscount)
    has_many(:staff_postings, StaffPosting)
    has_many(:item_image, ItemImage)
    has_many(:campus_agents, CampusAgent)

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
  def changeset(ecommerce_control, attrs) do
    ecommerce_control
    |> cast(attrs, [:name, :region, :country, :centre_code])
    |> validate_required([:name, :region, :country])
    # |> unique_constraint(:name)
    # |> unique_constraint(:region)
    |> get_unique_code
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def update_changeset(ecommerce_control, attrs) do
    ecommerce_control
    |> cast(attrs, [:name, :region, :country, :centre_code])
    |> validate_required([:name, :region, :country])
    |> unique_constraint(:name)
    |> unique_constraint(:region)
  end

  defp get_unique_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 4
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        actual_value =
          value
          |> String.upcase()

        changeset |> put_change(:centre_code, actual_value)

      _ ->
        changeset
    end
  end
end
