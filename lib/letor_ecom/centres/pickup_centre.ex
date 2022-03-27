defmodule LetorEcom.Centres.PickupCentre do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{ItemCategory, Sku}
  alias LetorEcom.Control.{CentreCode, EcommerceControl}

  schema "pickup_centres" do
    field :address, :string
    field :area, :string
    field :city, :string
    field :country, :string
    field :location_coordinates, :string
    field :name, :string
    field :state, :string
    belongs_to(:centre_code, CentreCode)
    belongs_to(:ecommerce_control, EcommerceControl)
    has_many(:item_categories, ItemCategory)
    has_many(:sku, Sku)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pickup_centre, attrs) do
    pickup_centre
    |> cast(attrs, [
      :centre_code_id,
      :ecommerce_control_id,
      :address,
      :name,
      :area,
      :city,
      :state,
      :country,
      :location_coordinates
    ])
    |> validate_required([
      :centre_code_id,
      :ecommerce_control_id,
      :address,
      :name,
      :area,
      :city,
      :state,
      :country,
      :location_coordinates
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
    |> assoc_constraint(:centre_code)
    |> assoc_constraint(:ecommerce_control)
  end
end
