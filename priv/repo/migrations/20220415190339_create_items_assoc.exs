defmodule LetorEcom.Repo.Migrations.CreateItemsAssoc do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :item_subcategory_id,
          references(:item_subcategories, on_delete: :nothing, type: :binary_id)

      add :sku_id, references(:sku, on_delete: :nothing, type: :binary_id)

      add :daily_deal_id,
          references(:daily_deals, on_delete: :nothing, type: :binary_id)

      add :featured_item_id, references(:featured_items, on_delete: :nothing, type: :binary_id)

      add :item_image_id,
          references(:item_images, on_delete: :nothing, type: :binary_id)
    end

    create index(:items, [:item_subcategory_id])
    create index(:items, [:sku_id])
    create index(:items, [:daily_deal_id])
    create index(:items, [:featured_item_id])
    create index(:items, [:item_image_id])
  end
end
