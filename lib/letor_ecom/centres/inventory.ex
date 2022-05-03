defmodule LetorEcom.Centres.Inventory do
  use Waffle.Ecto.Schema
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{ItemImage, Sku}

  alias LetorEcom.Centres.{
    InventoryLocation,
    InventoryChangeHistory,
    InventoryMetric,
    PickupCentre
  }

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
    has_one(:inventory_metrics, InventoryMetric)

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
    |> check_external_quantity_levels
    |> check_internal_quantity_levels
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:inventory_location)
    |> assoc_constraint(:item_image)
    |> assoc_constraint(:sku)
  end

  def update_changeset(inventory, attrs) do
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
    |> check_external_quantity_levels
    |> check_internal_quantity_levels
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:inventory_location)
    |> assoc_constraint(:item_image)
    |> assoc_constraint(:sku)
  end

  @spec qr_code_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def qr_code_changeset(item, attrs) do
    item
    |> cast(attrs, [:qr_code])
    |> cast_attachments(attrs, [:qr_code])
  end

  defp check_external_quantity_levels(changeset) do
    case changeset.valid? do
      true ->
        maximum_external_quantity = get_field(changeset, :maximum_external_quantity)
        external_quantity = get_field(changeset, :external_quantity)

        if external_quantity > maximum_external_quantity do
          add_error(
            changeset,
            :external_quantity_too_high,
            "External Quantity should not be higher than Maximum External Quantity"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp check_internal_quantity_levels(changeset) do
    case changeset.valid? do
      true ->
        maximum_internal_quantity = get_field(changeset, :maximum_internal_quantity)
        internal_quantity = get_field(changeset, :internal_quantity)

        if internal_quantity > maximum_internal_quantity do
          add_error(
            changeset,
            :internal_quantity_too_high,
            "Internal Quantity should not be higher than Maximum Internal Quantity"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end
