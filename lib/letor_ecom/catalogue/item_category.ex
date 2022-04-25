defmodule LetorEcom.Catalogue.ItemCategory do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre

  schema "item_categories" do
    field(:description, :string)
    field(:name, :string)
    belongs_to(:pickup_centre, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_category, attrs) do
    item_category
    |> cast(attrs, [:pickup_centre_id, :name, :description])
    |> validate_required([:pickup_centre_id, :name, :description])
    |> unique_constraint(:name,
      message: "Your centre already has an item category with the same name",
      name: :item_categories_name_pickup_centre_id_index
    )
    |> assoc_constraint(:pickup_centre)
  end

  @doc false
  def update_changeset(item_category, attrs) do
    item_category
    |> cast(attrs, [:pickup_centre_id, :name, :description])
    |> unique_constraint(:name,
      message: "Your centre already has an item category with the same name",
      name: :item_categories_name_pickup_centre_id_index
    )
    |> assoc_constraint(:pickup_centre)
  end
end
