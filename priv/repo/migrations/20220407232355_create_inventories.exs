defmodule LetorEcom.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:buy_price, :decimal)
      add(:description, :string)
      add(:max_bulk_quantity, :integer)
      add(:name, :string)
      add(:sales_unit_quantity, :integer)
      add(:bulk_quantity, :integer)
      add(:sales_unit_quantity_uom, :string)
      add(:bulk_quantity_uom, :string)
      add(:unit_sales_price, :decimal)
      add(:bulk_sales_price, :decimal)
      add(:quality_assurance_status, :string)
      add(:size, :integer)
      add(:status, :string)
      add(:expiry_date, :date)
      add(:expired, :boolean, default: false, null: false)
      add(:brand_name, :string)
      add(:qr_code, :string)
      add(:inventory_code, :string)
      add(:re_order_level, :integer)
      add(:re_ordering_required, :boolean)
      add(:shelf_replenishment_levels, :integer)
      add(:shelf_replenishment_required, :boolean)
      add(:pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id))

      add(
        :inventory_location_id,
        references(:inventory_location, on_delete: :nothing, type: :binary_id)
      )

      add(:item_image_id, references(:item_images, on_delete: :nothing, type: :binary_id))
      add(:sku_id, references(:sku, on_delete: :nothing, type: :binary_id))

      add(
        :item_subcategory_id,
        references(:item_subcategories, on_delete: :nothing, type: :binary_id)
      )

      timestamps(type: :timestamptz)
    end

    create(index(:inventories, [:id]))
    create(index(:inventories, [:pickup_centre_id]))
    create(index(:inventories, [:inventory_location_id]))
    create(index(:inventories, [:item_image_id]))
    create(index(:inventories, [:sku_id]))
    create(index(:inventories, [:item_subcategory_id]))
  end
end

pr
