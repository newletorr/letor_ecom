defmodule LetorEcom.Repo.Migrations.CreatePurchaseItemAssoc do
  use Ecto.Migration

  def change do
    alter table(:purchase_items) do
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)
      add :purchase_id, references(:purchases, on_delete: :nothing, type: :binary_id)
    end

    create index(:purchase_items, [:inventory_id])
    create index(:purchase_items, [:purchase_id])
  end
end
