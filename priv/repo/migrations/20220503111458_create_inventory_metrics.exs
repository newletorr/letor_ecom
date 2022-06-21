defmodule LetorEcom.Repo.Migrations.CreateInventoryMetrics do
  use Ecto.Migration

  def change do
    create table(:inventory_metrics, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :accuracy, :string
      add :days_on_hand, :decimal
      add :fill_rate, :decimal
      add :inventory_shrinkage, :decimal
      add :lead_time, :decimal
      add :lost_sales_ratio, :string
      add :perfect_order_rate, :decimal
      add :re_order_level, :decimal
      add :sell_through_rate, :decimal
      add :service_level, :decimal
      add :spoilt_quantity, :decimal
      add :stock_to_sales_ratio, :decimal
      add :supplier_quality_index, :decimal
      add :weeks_on_hand, :decimal
      add :back_order, :decimal

      timestamps(type: :timestamptz)
    end

    create index(:inventory_metrics, [:id])
  end
end
