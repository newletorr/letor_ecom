defmodule LetorEcom.Control.Location do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.AgentsAndSuppliers.Agent
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.Order
  alias Geo.PostGIS.Geometry

  schema "locations" do
    field :city, :string
    field :country, :string
    field :location_area, :string
    field :location_coordinates, Geometry
    field :postal_code, :string
    field :state, :string
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:agents, Agent)
    has_many(:users, User)
    has_many(:orders, Order)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [
      :pickup_centre_id,
      :city,
      :country,
      :location_area,
      :state,
      :postal_code,
      :location_coordinates
    ])
    |> validate_required([
      #:pickup_centre_id,
      :city,
      :country,
      :location_area,
      :state
      #:location_coordinates
    ])
    |> unique_constraint(:location_area)
    |> assoc_constraint(:pickup_centre)
  end
end
