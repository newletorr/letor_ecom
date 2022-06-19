defmodule LetorEcom.Centres.PurchaseItem do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{Inventory, Purchase}

  schema "purchase_items" do
    field :item_name, :string, read_after_writes: true
    field :quantity, :integer, read_after_writes: true
    field :suppliers_email, :string, read_after_writes: true
    field :suppliers_name, :string, read_after_writes: true
    field :suppliers_phone, :string, read_after_writes: true
    field :unit_of_measure, :string, read_after_writes: true
    field :total, :decimal, read_after_writes: true
    field :price_per_unit, :decimal, read_after_writes: true
    belongs_to(:inventory, Inventory)
    belongs_to(:purchase, Purchase)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def unknown_item_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :purchase_id,
      :price_per_unit,
      :item_name,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :unit_of_measure,
      :quantity,
      :total
    ])
    |> validate_required([:price_per_unit, :item_name, :quantity, :unit_of_measure])
    |> assoc_constraint(:purchase)
    |> get_total
  end

  def existing_item_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :inventory_id,
      :purchase_id,
      :price_per_unit,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :unit_of_measure,
      :quantity,
      :total
    ])
    |> validate_required([:inventory_id, :quantity])
    |> assoc_constraint(:inventory)
    |> assoc_constraint(:purchase)
    |> get_item_name
    |> get_unit_price
    |> get_unit_of_measure
    |> get_total
  end

  def update_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :inventory_id,
      :price_per_unit,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :unit_of_measure,
      :quantity,
      :total
    ])
    |> validate_required([:inventory_id, :quantity])
    |> assoc_constraint(:inventory)
    |> assoc_constraint(:purchase)
    |> get_item_name
    |> get_unit_price
    |> get_unit_of_measure
    |> get_total
  end

  defp get_item_name(changeset) do
    case changeset.valid? do
      true ->
        inventory_id = get_field(changeset, :inventory_id)
        inventory = Repo.get(Inventory, inventory_id)

        changeset |> put_change(:item_name, inventory.name)

      _ ->
        changeset
    end
  end

  defp get_unit_price(changeset) do
    case changeset.valid? do
      true ->
        inventory_id = get_field(changeset, :inventory_id)
        inventory = Repo.get(Inventory, inventory_id)

        changeset |> put_change(:price_per_unit, inventory.buy_price)

      _ ->
        changeset
    end
  end

  defp get_unit_of_measure(changeset) do
    case changeset.valid? do
      true ->
        inventory_id = get_field(changeset, :inventory_id)
        inventory = Repo.get(Inventory, inventory_id)

        changeset |> put_change(:unit_of_measure, inventory.bulk_quantity_uom)

      _ ->
        changeset
    end
  end

  defp get_total(changeset) do
    case changeset.valid? do
      true ->
        quantity = get_field(changeset, :quantity) |> Decimal.new()
        price_per_unit = get_field(changeset, :price_per_unit)
        total = Decimal.mult(quantity, price_per_unit)

        changeset |> put_change(:total, total)

      _ ->
        changeset
    end
  end
end
