defmodule LetorEcom.Repo.Migrations.CreateInventoryMetrics do
  use Ecto.Migration

  def change do
    create table(:inventory_metrics, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :re_order_level, :string
      add :fill_rate, :string
      add :accuracy, :string
      add :days_on_hand, :integer
      add :supplier_quality_index, :integer
      add :weeks_on_hand, :integer
      add :stock_to_sales_ratio, :string
      add :sell_through_rate, :string
      add :lost_sales_ratio, :string
      add :perfect_order_rate, :string
      add :inventory_shrinkage, :string
      add :service_level, :string
      add :lead_time, :string
      add :spoilt_quanity, :integer
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:inventory_metrics, [:id])
    create index(:inventory_metrics, [:inventory_id])
  end
end
