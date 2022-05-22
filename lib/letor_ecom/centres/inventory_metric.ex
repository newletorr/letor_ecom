defmodule LetorEcom.Centres.InventoryMetric do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.Inventory

  schema "inventory_metrics" do
    field :accuracy, :string, read_after_writes: true
    field :days_on_hand, :decimal, read_after_writes: true
    field :fill_rate, :decimal, read_after_writes: true
    field :inventory_shrinkage, :decimal, read_after_writes: true
    field :lead_time, :decimal, read_after_writes: true
    field :lost_sales_ratio, :string
    field :perfect_order_rate, :decimal, read_after_writes: true
    field :re_order_level, :decimal, read_after_writes: true
    field :sell_through_rate, :decimal, read_after_writes: true
    field :service_level, :decimal, read_after_writes: true
    field :spoilt_quantity, :decimal, read_after_writes: true
    field :stock_to_sales_ratio, :decimal, read_after_writes: true
    field :supplier_quality_index, :decimal, read_after_writes: true
    field :weeks_on_hand, :decimal, read_after_writes: true
    field :back_order, :decimal, read_after_writes: true
    field :inventory_turnover, :decimal, read_after_writes: true
    field :average_days_sells, :decimal, read_after_writes: true
    belongs_to(:inventory, Inventory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory_metric, attrs) do
    inventory_metric
    |> cast(attrs, [
      :inventory_id,
      :re_order_level,
      :fill_rate,
      :accuracy,
      :days_on_hand,
      :supplier_quality_index,
      :weeks_on_hand,
      :stock_to_sales_ratio,
      :sell_through_rate,
      :lost_sales_ratio,
      :perfect_order_rate,
      :inventory_shrinkage,
      :service_level,
      :lead_time,
      :spoilt_quantity
    ])
    |> assoc_constraint(:inventory)
  end
end
