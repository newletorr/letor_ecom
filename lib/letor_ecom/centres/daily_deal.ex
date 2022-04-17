defmodule LetorEcom.Centres.DailyDeal do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Centres.PickupCentre

  schema "daily_deals" do
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:items, Item)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(daily_deal, attrs) do
    daily_deal
    |> cast(attrs, [:pickup_centre_id])
    |> validate_required([:pickup_centre_id])
    |> assoc_constraint(:pickup_centre)
  end
end
