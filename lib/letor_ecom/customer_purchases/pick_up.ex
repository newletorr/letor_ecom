defmodule LetorEcom.CustomerPurchases.PickUp do
  use LetorEcom.SchemaHelper
  alias LetorEcom.AgentsAndSuppliers.CampusAgent
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.Order

  schema "pick_ups" do
    field :pick_up_time, :utc_datetime
    field :picked, :boolean, default: false
    field :pickup_code, :string
    belongs_to(:order, Order)
    belongs_to(:campus_agent, CampusAgent)
    belongs_to(:pickup_centre, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def campus_agent_changeset(pick_up, attrs) do
    pick_up
    |> cast(attrs, [:order_id, :campus_agent_id, :pick_up_time, :picked, :pickup_code])
    |> validate_required([:pick_up_time, :picked, :pickup_code])
    |> assoc_constraint(:order)
    |> assoc_constraint(:campus_agent)
  end

  def instore_pickup_changeset(pick_up, attrs) do
    pick_up
    |> cast(attrs, [:order_id, :pick_up_time, :picked, :pickup_code])
    |> validate_required([:pick_up_time, :picked, :pickup_code])
    |> assoc_constraint(:order)
  end
end
