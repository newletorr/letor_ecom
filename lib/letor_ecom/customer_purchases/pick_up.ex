defmodule LetorEcom.CustomerPurchases.PickUp do
  use LetorEcom.SchemaHelper
  # alias LetorEcom.AgentsAndSuppliers.CampusAgent
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.Order
  alias LetorEcom.HumanResource.Staff

  schema "pick_ups" do
    field :pick_up_time, :utc_datetime
    field :picked, :boolean, default: false
    field :pickup_code, :string
    field :payment_option, :string
    field :pos_ref, :string
    belongs_to(:order, Order)
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:staff, Staff)

    timestamps(type: :utc_datetime)
  end

  @spec instore_pickup_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def instore_pickup_changeset(pick_up, attrs) do
    pick_up
    |> cast(attrs, [:staff_id, :order_id, :pick_up_time, :picked, :pickup_code])
    |> validate_required([:pick_up_time, :picked, :pickup_code])
    |> assoc_constraint(:order)
    |> assoc_constraint(:staff)
  end
end
