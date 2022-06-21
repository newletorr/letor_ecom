defmodule LetorEcom.Repo.Migrations.CreatePurchaseItems do
  use Ecto.Migration

  def change do
    create table(:purchase_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :price_per_unit, :decimal
      add :item_name, :string
      add :suppliers_email, :string
      add :suppliers_phone, :string
      add :suppliers_name, :string
      add :quantity, :integer
      add :unit_of_measure, :string

      add :total, :decimal

      timestamps(type: :timestamptz)
    end

    create index(:purchase_items, [:id])
  end
end
