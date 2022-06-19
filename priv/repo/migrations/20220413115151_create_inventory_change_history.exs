defmodule LetorEcom.Repo.Migrations.CreateInventoryChangeHistory do
  use Ecto.Migration

  def change do
    create table(:inventory_change_history, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:buy_price, :decimal)
      add(:bulk_quantity, :integer)
      add(:sales_unit_quantity, :integer)
      add(:unit_sales_price, :decimal)
      add(:bulk_sales_price, :decimal)
      add(:change_type, :string)

      timestamps(type: :timestamptz)
    end

    create(index(:inventory_change_history, [:id]))
  end
end
