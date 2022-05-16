defmodule LetorEcom.Sales.InstoreSale do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Sales.Sale
  alias LetorEcom.Catalogue.Item

  schema "instore_sales" do
    field :item_price, :decimal, read_after_writes: true
    field :quantity, :integer, read_after_writes: true
    field :sales_amount, :decimal, read_after_writes: true
    belongs_to(:sale, Sale)
    belongs_to(:item, Item)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(instore_sale, attrs) do
    instore_sale
    |> cast(attrs, [:sale_id, :item_id, :quantity, :item_price, :sales_amount])
    |> validate_required([:sale_id, :item_id, :quantity, :item_price, :sales_amount])
    |> assoc_constraint(:sale)
    |> assoc_constraint(:item)
    |> get_item_price
    |> calculate_sales_amount
  end

  def update_changeset(in_store_sales, attrs) do
    in_store_sales
    |> cast(attrs, [:item_id, :sale_id, :quantity, :item_price, :sales_amount])
    |> assoc_constraint(:sale)
    |> assoc_constraint(:item)
    |> get_item_price
    |> calculate_sales_amount
  end

  defp get_item_price(changeset) do
    case changeset.valid? do
      true ->
        item = Repo.get(Item, get_field(changeset, :item_id))

        changeset |> put_change(:item_price, item.actual_price)

      _ ->
        changeset
    end
  end

  defp calculate_sales_amount(changeset) do
    case changeset.valid? do
      true ->
        item_price = get_field(changeset, :item_price)

        quantity = get_field(changeset, :quantity) |> Decimal.new()

        sales_amount = Decimal.mult(item_price, quantity)

        changeset |> put_change(:sales_amount, sales_amount)

      _ ->
        changeset
    end
  end
end
