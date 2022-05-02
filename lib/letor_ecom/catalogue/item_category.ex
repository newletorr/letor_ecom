defmodule LetorEcom.Catalogue.ItemCategory do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.ItemSubcategory
  alias LetorEcom.Centres.PickupCentre

  schema "item_categories" do
    field(:description, :string)
    field(:name, :string)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:item_subcategories, ItemSubcategory)

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

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
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
