defmodule LetorEcom.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :buy_price, :decimal
      add :description, :string
      add :max_external_quantity, :integer
      add :max_internal_quantity, :integer
      add :name, :string
      add :internal_quantity, :integer
      add :external_quantity, :integer
      add :internal_quantity_uom, :string
      add :external_quantity_uom, :string
      add :sales_price, :decimal
      add :quality_assurance_status, :string
      add :size, :integer
      add :status, :string
      add :expiry_date, :date
      add :expired, :boolean, default: false, null: false
      add :brand_name, :string
      add :qr_code, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      add :inventory_location_id,
          references(:inventory_location, on_delete: :nothing, type: :binary_id)

      add :item_image_id, references(:item_images, on_delete: :nothing, type: :binary_id)
      add :sku_id, references(:sku, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:inventories, [:pickup_centre_id])
    create index(:inventories, [:inventory_location_id])
    create index(:inventories, [:item_image_id])
    create index(:inventories, [:sku_id])
  end
end
