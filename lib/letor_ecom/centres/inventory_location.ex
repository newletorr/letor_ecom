defmodule LetorEcom.Centres.InventoryLocation do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{Inventory, PickupCentre}

  schema "inventory_location" do
    field(:name, :string, read_after_writes: true)
    field(:type, :string, read_after_writes: true)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:inventories, Inventory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory_location, attrs) do
    inventory_location
    |> cast(attrs, [:pickup_centre_id, :name, :type])
    |> validate_required([:pickup_centre_id, :name, :type])
    |> assoc_constraint(:pickup_centre)
    |> no_assoc_constraint(:inventories)
  end
end
