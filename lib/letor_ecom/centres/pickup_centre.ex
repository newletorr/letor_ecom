defmodule LetorEcom.Centres.PickupCentre do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{ItemCategory, Sku}

  alias LetorEcom.Centres.{
    EcommerceControl,
    InventoryLocation,
    DailyDeal,
    FeaturedItem,
    PopularItem
  }

  alias LetorEcom.CustomerPurchases.{Order, PickUp}
  alias LetorEcom.Delicacies.RecipeClass
  alias LetorEcom.HumanResource.Driver
  alias Geo.PostGIS.Geometry

  schema "pickup_centres" do
    field :address, :string
    field :area, :string
    field :city, :string
    field :country, :string
    field :longitude_and_latitude_point, Geometry
    field :name, :string
    field :state, :string
    field :centre_code, :string
    belongs_to(:ecommerce_control, EcommerceControl)
    has_many(:item_categories, ItemCategory)
    has_many(:sku, Sku)
    has_many(:order, Order)
    has_many(:driver, Driver)
    has_many(:inventory_location, InventoryLocation)
    has_many(:daily_deals, DailyDeal)
    has_many(:featured_item, FeaturedItem)
    has_many(:popular_item, PopularItem)
    has_many(:pick_ups, PickUp)
    has_many(:recipe_class, RecipeClass)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pickup_centre, attrs) do
    pickup_centre
    |> cast(attrs, [
      :ecommerce_control_id,
      :address,
      :name,
      :area,
      :city,
      :state,
      :country,
      :longitude_and_latitude_point,
      :centre_code
    ])
    |> validate_required([
      :ecommerce_control_id,
      :address,
      :name,
      :area,
      :city,
      :state,
      :country,
      :longitude_and_latitude_point
    ])
    |> unique_constraint(:name, message: "A centre with the same already exists")
    |> unique_constraint(:address, message: "A centre with the same address already exists")
    |> unique_constraint(:area,
      message: "There is a centre in this location already",
      name: :pickup_centres_area_city_index
    )
    |> unique_constraint(:centre_code_id,
      message: "A centre with the same centre code already exists"
    )
    |> assoc_constraint(:ecommerce_control)
    |> gen_centre_code
  end

  def update_changeset(pickup_centre, attrs) do
    pickup_centre
    |> cast(attrs, [
      :ecommerce_control_id,
      :address,
      :name,
      :area,
      :city,
      :state,
      :country,
      :longitude_and_latitude_point
    ])
    |> unique_constraint(:name, message: "A centre with the same name already exists")
    |> unique_constraint(:address, message: "A centre with the same address already exists")
    |> unique_constraint(:area,
      message: "There is a centre in this location already",
      name: :pickup_centres_area_city_index
    )
    |> unique_constraint(:centre_code_id,
      message: "A centre with the same centre code already exists"
    )
  end

  defp gen_centre_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 8
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        actual_value =
          value
          |> String.upcase()

        changeset |> put_change(:centre_code, actual_value)

      _ ->
        changeset
    end
  end
end
