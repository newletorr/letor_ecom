defmodule LetorEcom.Repo.Migrations.CreatePurchaseItems do
  use Ecto.Migration

  def change do
    create table(:purchase_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :unit_price, :decimal
      add :item_name, :string
      add :suppliers_email, :string
      add :suppliers_phone, :string
      add :suppliers_name, :string
      add :quantity, :integer
      add :total, :decimal
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)
      add :purchase_id, references(:purchases, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:purchase_items, [:inventory_id])
    create index(:purchase_items, [:purchase_id])
  end
end
