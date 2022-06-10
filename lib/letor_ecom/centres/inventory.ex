defmodule LetorEcom.Centres.Inventory do
  use Waffle.Ecto.Schema
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{ItemImage, Sku}

  alias LetorEcom.Centres.{
    InventoryLocation,
    InventoryChangeHistory,
    InventoryMetric,
    PickupCentre,
    PurchaseItem
  }

  schema "inventories" do
    field :brand_name, :string, read_after_writes: true
    field :buy_price, :decimal, read_after_writes: true
    field :description, :string, read_after_writes: true
    field :expired, :boolean, default: false, read_after_writes: true
    field :expiry_date, :date, read_after_writes: true
    field :bulk_quantity, :integer, read_after_writes: true
    field :bulk_quantity_uom, :string, read_after_writes: true
    field :sales_unit_quantity_uom, :string, read_after_writes: true
    field :sales_unit_quantity, :integer, read_after_writes: true
    field :max_bulk_quantity, :integer, read_after_writes: true
    field :name, :string, read_after_writes: true
    field :qr_code, :string, read_after_writes: true
    field :quality_assurance_status, :string, read_after_writes: true
    field :unit_sales_price, :decimal, read_after_writes: true
    field :bulk_sales_price, :decimal, read_after_writes: true
    field :size, :integer, read_after_writes: true
    field :status, :string, read_after_writes: true
    field :inventory_code, :string, read_after_writes: true
    field :re_order_level, :integer, read_after_writes: true
    field :re_ordering_required, :boolean, read_after_writes: true
    field :shelf_replenishment_levels, :integer, read_after_writes: true
    field :shelf_replenishment_required, :boolean, read_after_writes: true
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:inventory_location, InventoryLocation)
    belongs_to(:item_image, ItemImage)
    belongs_to(:sku, Sku)
    has_many(:inventory_change_history, InventoryChangeHistory)
    has_many(:inventory_metrics, InventoryMetric)
    has_many(:purchase_items, PurchaseItem)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [
      :inventory_location_id,
      :item_image_id,
      :pickup_centre_id,
      :sku_id,
      :buy_price,
      :description,
      :max_bulk_quantity,
      :name,
      :sales_unit_quantity,
      :bulk_quantity,
      :sales_unit_quantity_uom,
      :bulk_quantity_uom,
      :unit_sales_price,
      :bulk_sales_price,
      :quality_assurance_status,
      :size,
      :status,
      :expiry_date,
      :expired,
      :brand_name,
      :qr_code,
      :inventory_code,
      :re_order_level
    ])
    |> validate_required([
      :inventory_location_id,
      :item_image_id,
      :sku_id,
      :buy_price,
      :description,
      :max_bulk_quantity,
      :name,
      :sales_unit_quantity,
      :bulk_quantity,
      :sales_unit_quantity_uom,
      :bulk_quantity_uom,
      :unit_sales_price,
      :bulk_sales_price,
      :re_order_level
    ])
    |> check_bulk_quantity_levels
    |> check_sales_unit_quantity_levels
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:inventory_location)
    |> assoc_constraint(:item_image)
    |> assoc_constraint(:sku)
    |> gen_inventory_code
  end

  def update_changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [
      :buy_price,
      :description,
      :max_bulk_quantity,
      :max_sales_unit_quantity,
      :name,
      :sales_unit_quantity,
      :bulk_quantity,
      :sales_unit_quantity_uom,
      :bulk_quantity_uom,
      :unit_sales_price,
      :quality_assurance_status,
      :size,
      :status,
      :expiry_date,
      :expired,
      :brand_name,
      :qr_code
    ])
    |> check_bulk_quantity_levels
    |> check_sales_unit_quantity_levels
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

    # |> cast_attachments(attrs, [:qr_code])
  end

  defp check_bulk_quantity_levels(changeset) do
    case changeset.valid? do
      true ->
        maximum_bulk_quantity = get_field(changeset, :maximum_bulk_quantity)
        bulk_quantity = get_field(changeset, :bulk_quantity)

        if bulk_quantity > maximum_bulk_quantity do
          add_error(
            changeset,
            :bulk_quantity_too_high,
            "External Quantity should not be higher than Maximum External Quantity"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp check_sales_unit_quantity_levels(changeset) do
    case changeset.valid? do
      true ->
        maximum_sales_unit_quantity = get_field(changeset, :maximum_sales_unit_quantity)
        sales_unit_quantity = get_field(changeset, :sales_unit_quantity)

        if sales_unit_quantity > maximum_sales_unit_quantity do
          add_error(
            changeset,
            :sales_unit_quantity_too_high,
            "Internal Quantity should not be higher than Maximum Internal Quantity"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp gen_inventory_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 7
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        changeset |> put_change(:inventory_code, value)

      _ ->
        changeset
    end
  end

  defp valid_reorder_level(changeset) do
    case changeset.valid? do
      true ->
        re_order_level = get_field(changeset, :re_order_level)

        max_bulk_quantity = get_field(changeset, :max_bulk_quantity)

        if re_order_level >= max_bulk_quantity do
          add_error(
            changeset,
            :re_order_level_too_high,
            "re-order level should not be greater than or equal to maximum bulk quantity"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end
