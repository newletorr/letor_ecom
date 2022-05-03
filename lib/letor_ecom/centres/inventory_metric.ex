defmodule LetorEcom.Centres.InventoryMetric do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.Inventory

  schema "inventory_metrics" do
    field :accuracy, :string
    field :days_on_hand, :integer
    field :fill_rate, :string
    field :inventory_shrinkage, :string
    field :lead_time, :string
    field :lost_sales_ratio, :string
    field :perfect_order_rate, :string
    field :re_order_level, :string
    field :sell_through_rate, :string
    field :service_level, :string
    field :spoilt_quanity, :integer
    field :stock_to_sales_ratio, :string
    field :supplier_quality_index, :integer
    field :weeks_on_hand, :integer
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
      :spoilt_quanity
    ])
    |> validate_required([
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
      :spoilt_quanity
    ])
    |> assoc_constraint(:inventory)
  end
end
