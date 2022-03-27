defmodule LetorEcom.Catalogue.ItemSubcategory do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.ItemCategory

  schema "item_subcategories" do
    field :description, :string
    field :name, :string
    belongs_to(:item_category, ItemCategory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_subcategory, attrs) do
    item_subcategory
    |> cast(attrs, [:item_category_id, :name, :description])
    |> validate_required([:item_category_id, :name, :description])
    |> unique_constraint(:name,
      message: "A subcategory with the same name already exist in this Category",
      name: :item_subcategories_name_item_category_id_index
    )
    |> assoc_constraint(:item_category)

    # |> no_assoc_constraint(:items,
    #  message:
    #   "Sorry you can't delete Subcategories that are already associated with existing items"
    # )
  end
end
