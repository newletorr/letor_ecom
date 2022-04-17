defmodule LetorEcom.Control.Location do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre
  alias Geo.PostGIS.Geometry

  schema "location" do
    field :city, :string
    field :country, :string
    field :location_area, :string
    field :longitude_and_latitude_point, Geometry
    field :postal_code, :string
    field :state, :string
    belongs_to(:pickup_centre, PickupCentre)
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
      :longitude_and_latitude_point
    ])
    |> validate_required([
      :pickup_centre_id,
      :city,
      :country,
      :location_area,
      :state
      #  :longitude_and_latitude_point
    ])
    |> assoc_constraint(:pickup_centre)
  end
end
