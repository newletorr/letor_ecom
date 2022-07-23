defmodule LetorEcom.Catalogue.Item do
  use LetorEcom.SchemaHelper
  use Waffle.Ecto.Schema
  alias LetorEcom.Account.ShoppingList
  alias LetorEcom.Catalogue.{ItemImage, ItemSubcategory, ItemTag, ItemTagging, Sku}
  alias LetorEcom.Centres.{DailyDeal, FeaturedItem}
  alias LetorEcom.CustomerPurchases.{CartItem, Order}
  alias LetorEcom.Repo

  schema "items" do
    field(:actual_price, :decimal, read_after_writes: true)
    field(:availability_time, :string, read_after_writes: true)
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
    field(:package_uom, :string, read_after_writes: true)
    field(:preparation_time, :string, read_after_writes: true)
    field(:promo_price, :decimal, read_after_writes: true)
    field(:qa_cleared, :boolean, default: false, read_after_writes: true)
    field(:qr_code, LetorEcom.Uploads.Type, read_after_writes: true)
    field(:regional_name, :string, read_after_writes: true)
    field(:size, :integer, read_after_writes: true)
    field(:third_party_item, :string, read_after_writes: true)
    field(:type, :string, read_after_writes: true)
    field(:instore_location, :string, read_after_writes: true)
    field(:ingredients, :string, read_after_writes: true)
    many_to_many(:item_tag, ItemTag, join_through: ItemTagging)
    belongs_to(:item_image, ItemImage)
    belongs_to(:item_subcategory, ItemSubcategory)
    belongs_to(:sku, Sku)
    belongs_to(:daily_deal, DailyDeal)
    belongs_to(:featured_item, FeaturedItem)
    has_many(:cart_items, CartItem)
    has_many(:item_taggings, ItemTagging)
    has_many(:order, Order)

    has_many(:shopping_lisdriverts, ShoppingList)

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
      :item_image_id,
      :actual_price,
      :description,
      :instore_location,
      :main_price,
      :group_buying_price,
      :name,
      :regional_name,
      :out_of_stock,
      :package_uom,
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
      :third_party_item,
      :ingredients
    ])
    |> validate_required([
      :sku_id,
      :item_image_id,
      :item_subcategory_id,
      :description,
      :main_price,
      :name,
      :package_uom,
      :type
    ])
    |> get_actual_price
    |> assoc_constraint(:item_subcategory)
    |> assoc_constraint(:sku)
    |> assoc_constraint(:item_image)
    |> gen_item_code
    |> get_item_location
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
      :description,
      :main_price,
      :group_buying_price,
      :name,
      :regional_name,
      :instore_location,
      :out_of_stock,
      :package_uom,
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
    |> cast(attrs, [:featured_item_id, :daily_deal_id])
    |> assoc_constraint(:daily_deal)
    |> assoc_constraint(:featured_item)
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
    |> cast_attachments(attrs, [:qr_code], allow_urls: true)
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
            from(item_subcategory in ItemSubcategory,
              join: item_category in assoc(item_subcategory, :item_category),
              join: pickup_centre in assoc(item_category, :pickup_centre),
              join: inventory in assoc(pickup_centre, :inventories),
              join: inventory_location in assoc(inventory, :inventory_location),
              where: item_subcategory.id == ^item_subcategory_id and inventory.name == ^name,
              select: inventory_location.name
            )
          )

        changeset |> put_change(:instore_location, item_location_name)

      _ ->
        changeset
    end
  end

  defp gen_item_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 5
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        changeset |> put_change(:item_code, value)

      _ ->
        changeset
    end
  end
end
