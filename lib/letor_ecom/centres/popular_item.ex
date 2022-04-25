defmodule LetorEcom.Centres.PopularItem do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Centres.PickupCentre

  schema "popular_items" do
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:items, Item)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(popular_item, attrs) do
    popular_item
    |> cast(attrs, [:pickup_centre_id])
    |> validate_required([:pickup_centre_id])
    |> assoc_constraint(:pickup_centre)
  end
end
