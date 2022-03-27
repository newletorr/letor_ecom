defmodule LetorEcom.Catalogue.Sku do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre

  schema "sku" do
    field :code, :string
    field :item_name, :string
    belongs_to(:pickup_centre, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [:pickup_centre_id, :code, :item_name])
    |> validate_required([:pickup_centre_id, :code, :item_name])
    |> assoc_constraint(:pickup_centre)
    |> unique_constraint(:item_name,
      message: "Item with the same name already exists",
      name: :sku_item_name_pickup_centre_id_index
    )
    |> assoc_constraint(:pickup_centre)
  end
end
