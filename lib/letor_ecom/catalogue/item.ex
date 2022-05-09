defmodule LetorEcom.Catalogue.Item do
  use LetorEcom.SchemaHelper
  use Waffle.Ecto.Schema
  alias LetorEcom.Account.ShoppingList
  alias LetorEcom.Catalogue.{ItemSubcategory, ItemTag, ItemTagging, Sku}
  alias LetorEcom.Centres.{DailyDeal, FeaturedItem, PopularItem}
  alias LetorEcom.CustomerPurchases.CartItem
  alias LetorEcom.Repo

  schema "items" do
    field(:actual_price, :decimal, read_after_writes: true)
    field(:availability_time, :string, read_after_writes: true)
    field(:available_quantity, :integer, read_after_writes: true)
    field(:barcode, :string, read_after_writes: true)
    field(:brand_name, :string, read_after_writes: true)
    field(:bulk, :boolean, default: false, read_after_writes: true)
    field(:customization_allowed, :boolean, default: false, read_after_writes: true)
    field(:description, :string, read_after_writes: true)
    field(:details, :string, read_after_writes: true)
    field(:expired, :boolean, default: false, read_after_writes: true)
    field(:group_buying_price, :decimal, read_after_writes: true)
    field(:item_code, :string, read_after_writes: true)
    field(:main_price, :decimal, read_after_writes: true)
    field(:name, :string, read_after_writes: true)
    field(:out_of_stock, :boolean, default: false, read_after_writes: true)
    field(:package_size, :string, read_after_writes: true)
    field(:preparation_time, :string, read_after_writes: true)
    field(:promo_price, :decimal, read_after_writes: true)
    field(:qa_cleared, :boolean, default: false, read_after_writes: true)
    # LetorEcom.Uploads.Type, read_after_writes: true)
    field(:qr_code, :string)
    field(:regional_name, :string, read_after_writes: true)
    field(:size, :integer, read_after_writes: true)
    field(:third_party_item, :string, read_after_writes: true)
    field(:type, :string, read_after_writes: true)
    field(:instore_location, :string, read_after_writes: true)
    many_to_many(:item_tag, ItemTag, join_through: ItemTagging)
    belongs_to(:item_subcategory, ItemSubcategory)
    belongs_to(:sku, Sku)
    belongs_to(:daily_deal, DailyDeal)
    belongs_to(:featured_item, FeaturedItem)
    belongs_to(:popular_item, PopularItem)
    has_many(:cart_items, CartItem)
    has_many(:item_taggings, ItemTagging)

    has_many(:shopping_lists, ShoppingList)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :sku_id,
      :item_subcategory_id,
      :actual_price,
      :available_quantity,
      :description,
      :main_price,
      :group_buying_price,
      :name,
      :regional_name,
      :out_of_stock,
      :package_size,
      :promo_price,
      :brand_name,
      :type,
      :qa_cleared,
      :size,
      :item_code,
      :expired,
      :details,
      :barcode,
      :qr_code,
      :bulk,
      :customization_allowed,
      :preparation_time,
      :availability_time,
      :third_party_item
    ])
    |> validate_required([
      :sku_id,
      :item_subcategory_id,
      :description,
      :main_price,
      :name,
      :package_size,
      :type
    ])
    |> get_actual_price
    |> assoc_constraint(:item_subcategory)
    |> assoc_constraint(:sku)
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def update_changeset(item, attrs) do
    item
    |> cast(attrs, [
      :sku_id,
      :item_subcategory_id,
      :actual_price,
      :available_quantity,
      :description,
      :main_price,
      :group_buying_price,
      :name,
      :regional_name,
      :out_of_stock,
      :package_size,
      :promo_price,
      :brand_name,
      :type,
      :qa_cleared,
      :size,
      :item_code,
      :expired,
      :details,
      :barcode,
      :qr_code,
      :bulk,
      :customization_allowed,
      :preparation_time,
      :availability_time,
      :third_party_item
    ])
    |> get_actual_price
    |> assoc_constraint(:item_subcategory)
    |> assoc_constraint(:sku)
    |> assoc_constraint(:daily_deal)
    |> assoc_constraint(:featured_item)
    |> assoc_constraint(:popular_item)
  end

  @spec special_category_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def special_category_changeset(item, attrs) do
    item
    |> cast(attrs, [:featured_item_id, :daily_deal_id, :popular_item_id])
    |> assoc_constraint(:daily_deal)
    |> assoc_constraint(:featured_item)
    |> assoc_constraint(:popular_item)
    |> assoc_constraint(:item_subcategory)
    |> assoc_constraint(:sku)
  end

  @spec qr_code_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def qr_code_changeset(item, attrs) do
    item
    |> cast(attrs, [:qr_code])

    # |> cast_attachments(attrs, [:qr_code], allow_urls: true)
  end

  def deletion_changeset(item, attrs \\ %{}) do
    item
    |> cast(attrs, [
      :daily_deal_id,
      :featured_item_id,
      :popular_item_id,
      :item_subcategory_id,
      :sku_id
    ])
    |> assoc_constraint(:daily_deal, name: :items_daily_deal_index)
    |> assoc_constraint(:featured_item, name: :items_featured_item_index)
    |> assoc_constraint(:popular_item, name: :items_popular_item_index)
    |> assoc_constraint(:item_subcategory, name: :items_item_subcategory_index)
    |> assoc_constraint(:sku, name: :items_sku_index)
  end

  defp get_actual_price(changeset) do
    case changeset.valid? do
      true ->
        main_price = get_field(changeset, :main_price)
        promo_price = get_field(changeset, :promo_price)

        case is_nil(promo_price) == false do
          true ->
            changeset
            |> put_change(:actual_price, promo_price)

          _ ->
            changeset
            |> put_change(:actual_price, main_price)
        end

      _ ->
        changeset
    end
  end

  defp get_item_location(changeset) do
    case changeset.valid? do
      true ->
        item_subcategory_id = get_field(changeset, :item_subcategory_id)
        name = get_field(changeset, :name)

        item_location_name =
          Repo.one(
            from(i in ItemSubcategory,
              join: it in assoc(i, :item_category),
              join: p in assoc(it, :pickup_centre),
              join: c in assoc(p, :centre_inventory),
              join: cl in assoc(c, :centre_inventory_location),
              where: i.id == ^item_subcategory_id and c.name == ^name,
              select: cl.name
            )
          )

        changeset |> put_change(:instore_location, item_location_name)

      _ ->
        changeset
    end
  end
end
