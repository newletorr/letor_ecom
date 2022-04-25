defmodule LetorEcom.Centres.Inventory do
  use Waffle.Ecto.Schema
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{ItemImage, Sku}
  alias LetorEcom.Centres.{InventoryLocation, InventoryChangeHistory, PickupCentre}

  schema "inventories" do
    field :brand_name, :string, read_after_writes: true
    field :buy_price, :decimal, read_after_writes: true
    field :description, :string, read_after_writes: true
    field :expired, :boolean, default: false, read_after_writes: true
    field :expiry_date, :date, read_after_writes: true
    field :external_quantity, :integer, read_after_writes: true
    field :external_quantity_uom, :string, read_after_writes: true
    field :internal_quantity_uom, :string, read_after_writes: true
    field :internal_quantity, :integer, read_after_writes: true
    field :max_external_quantity, :integer, read_after_writes: true
    field :max_internal_quantity, :integer, read_after_writes: true
    field :name, :string, read_after_writes: true
    field :qr_code, :string, read_after_writes: true
    field :quality_assurance_status, :string, read_after_writes: true
    field :sales_price, :decimal, read_after_writes: true
    field :size, :integer, read_after_writes: true
    field :status, :string, read_after_writes: true
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:inventory_location, InventoryLocation)
    belongs_to(:item_image, ItemImage)
    belongs_to(:sku, Sku)
    has_many(:inventory_change_history, InventoryChangeHistory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [
      :buy_price,
      :description,
      :max_external_quantity,
      :max_internal_quantity,
      :name,
      :internal_quantity,
      :external_quantity,
      :internal_quantity_uom,
      :external_quantity_uom,
      :sales_price,
      :quality_assurance_status,
      :size,
      :status,
      :expiry_date,
      :expired,
      :brand_name,
      :qr_code
    ])
    |> validate_required([
      :buy_price,
      :description,
      :max_external_quantity,
      :max_internal_quantity,
      :name,
      :internal_quantity,
      :external_quantity,
      :internal_quantity_uom,
      :external_quantity_uom,
      :sales_price
    ])
  end

  def qr_code_changeset(item, attrs) do
    item
    |> cast(attrs, [:qr_code])
    |> cast_attachments(attrs, [:qr_code])
  end
end
