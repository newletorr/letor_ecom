defmodule LetorEcom.Account.ShoppingList do
  @required_fields [:item_id, :quantity]
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Repo

  schema "shopping_lists" do
    field :quantity, :integer, read_after_writes: true
    field :title, :string, read_after_writes: true
    field :item_price, :decimal, read_after_writes: true
    field :total, :decimal, read_after_writes: true
    belongs_to(:item, Item)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shopping_list, attrs) do
    shopping_list
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
    |> unique_constraint(:title, name: :shopping_lists_title_user_id_index)
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(shopping_list, attrs) do
    shopping_list
    |> cast(attrs, [:item_price, :quantity, :item_id, :total])
    |> validate_required(@required_fields)
    |> get_item_price
    |> calculate_total
    |> assoc_constraint(:item)
  end

  def quantity_update_changeset(shopping_list, attrs) do
    shopping_list
    |> cast(attrs, [:item_price, :quantity])
    |> validate_required([:quantity])
    |> get_item_price
    |> calculate_total
  end

  defp get_item_price(changeset) do
    case changeset.valid? do
      true ->
        item_id = get_field(changeset, :item_id)
        item = Repo.get(Item, item_id)

        changeset |> put_change(:item_price, item.actual_price)

      _ ->
        changeset
    end
  end

  defp calculate_total(changeset) do
    case changeset.valid? do
      true ->
        quantity = get_field(changeset, :quantity) |> Decimal.new()
        item_price = get_field(changeset, :item_price)
        total = Decimal.mult(quantity, item_price)
        changeset |> put_change(:total, total)

      _ ->
        changeset
    end
  end
end
