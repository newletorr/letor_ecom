defmodule LetorEcom.Centres.InventoryChangeHistory do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.Inventory

  schema "inventory_change_history" do
    field :buy_price, :decimal, read_after_writes: true
    field :bulk_quantity, :integer, read_after_writes: true
    field :sales_unit_quantity, :integer, read_after_writes: true
    field :unit_sales_price, :decimal, read_after_writes: true
    field :bulk_sales_price, :decimal, read_after_writes: true
    field :change_type, :string, read_after_writes: true
    belongs_to(:inventory, Inventory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory_change_history, attrs) do
    inventory_change_history
    |> cast(attrs, [
      :inventory_id,
      :buy_price,
      :bulk_quantity,
      :sales_unit_quantity,
      :unit_sales_price,
      :bulk_sales_price,
      :change_type
    ])
    |> validate_required([
      :inventory_id,
      :buy_price,
      :bulk_quantity,
      :sales_unit_quantity,
      :unit_sales_price,
      :bulk_sales_price,
      :change_type
    ])
    |> assoc_constraint(:inventory)
  end
end
