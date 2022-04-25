defmodule LetorEcom.CustomerPurchases.CartItem do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.CustomerPurchases.Order
  alias LetorEcom.Repo

  schema "cart_items" do
    field :additional_info, :string, read_after_writes: true
    field :decline_item, :boolean, default: false, read_after_writes: true
    field :quantity, :integer, read_after_writes: true
    field :sold, :boolean, default: false, read_after_writes: true
    field :sub_total, :decimal, read_after_writes: true
    field :purchase_price, :decimal, read_after_writes: true
    belongs_to(:item, Item)
    belongs_to(:order, Order)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [
      :quantity,
      :sub_total,
      :item_id,
      :order_id,
      :additional_info,
      :sold,
      :purchase_price
    ])
    |> validate_required([:quantity, :item_id, :order_id])
    |> assoc_constraint(:item)
    |> assoc_constraint(:order)
    |> get_purchase_price
    |> calculate_sub_total
  end

  @doc false
  def sold_changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [:sold])
  end

  @doc false
  def decline_changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [:decline_item])
  end

  @doc false
  def quantity_changeset(cart_items, attrs) do
    cart_items
    |> cast(attrs, [:quantity, :item_id, :sold, :additional_info])
    |> get_purchase_price
    |> calculate_sub_total
  end

  defp get_purchase_price(changeset) do
    case changeset.valid? do
      true ->
        item = Repo.get(Item, get_field(changeset, :item_id))

        purchase_price = item.actual_price
        changeset |> put_change(:purchase_price, purchase_price)

      _ ->
        changeset
    end
  end

  defp calculate_sub_total(changeset) do
    case changeset.valid? do
      true ->
        purchase_price = get_field(changeset, :purchase_price)
        quantity = get_field(changeset, :quantity)

        sub_total = Decimal.mult(purchase_price, quantity)

        changeset
        |> put_change(:sub_total, sub_total)

      _ ->
        changeset
    end
  end
end
