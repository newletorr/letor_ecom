defmodule LetorEcom.Catalogue.ItemSubcategory do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{Item, ItemCategory}
  alias LetorEcom.Centres.Inventory

  schema "item_subcategories" do
    field(:description, :string)
    field(:name, :string)
    belongs_to(:item_category, ItemCategory)
    has_many(:items, Item)
    has_many(:inventory, Inventory)

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
  def changeset(item_subcategory, attrs) do
    item_subcategory
    |> cast(attrs, [:item_category_id, :name, :description])
    |> validate_required([:item_category_id, :name, :description])
    |> unique_constraint(:name,
      message: "A subcategory with the same name already exist in this Category",
      name: :item_subcategories_name_item_category_id_index
    )
    |> foreign_key_constraint(:item_category_id)
  end

  @doc false
  def update_changeset(item_subcategory, attrs) do
    item_subcategory
    |> cast(attrs, [:item_category_id, :name, :description])
    |> unique_constraint(:name,
      message: "A subcategory with the same name already exist in this Category",
      name: :item_subcategories_name_item_category_id_index
    )
    |> assoc_constraint(:item_category)
  end
end
