defmodule LetorEcom.Centres.PurchaseItem do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{Inventory, Purchase}

  schema "purchase_items" do
    field :item_name, :string, read_after_writes: true
    field :quantity, :integer, read_after_writes: true
    field :suppliers_email, :string, read_after_writes: true
    field :suppliers_name, :string, read_after_writes: true
    field :suppliers_phone, :string, read_after_writes: true
    field :total, :decimal, read_after_writes: true
    field :unit_price, :decimal, read_after_writes: true
    belongs_to(:inventory, Inventory)
    belongs_to(:purchase, Purchase)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def unknown_item_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :purchase_id,
      :unit_price,
      :item_name,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :quantity,
      :total
    ])
    |> validate_required([:unit_price, :item_name, :quantity])
    |> assoc_constraint(:purchase)
    |> get_total
  end

  def existing_item_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :inventory_id,
      :purchase_id,
      :unit_price,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :quantity,
      :total
    ])
    |> validate_required([:inventory_id, :unit_price, :item_name, :quantity])
    |> assoc_constraint(:inventory)
    |> assoc_constraint(:purchase)
    |> get_item_name
    |> get_unit_price
    |> get_total
  end

  def update_changeset(purchase_item, attrs) do
    purchase_item
    |> cast(attrs, [
      :inventory_id,
      :unit_price,
      :suppliers_email,
      :suppliers_phone,
      :suppliers_name,
      :quantity,
      :total
    ])
    |> validate_required([:inventory_id, :unit_price, :item_name, :quantity])
    |> assoc_constraint(:inventory)
    |> assoc_constraint(:purchase)
    |> get_item_name
    |> get_unit_price
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

        changeset |> put_change(:unit_price, inventory.buy_price)

      _ ->
        changeset
    end
  end

  defp get_total(changeset) do
    case changeset.valid? do
      true ->
        quantity = get_field(changeset, :quantity) |> Decimal.new()
        unit_price = get_field(changeset, :unit_price)
        total = Decimal.mult(quantity, unit_price)

        changeset |> put_change(:total, total)

      _ ->
        changeset
    end
  end
end
