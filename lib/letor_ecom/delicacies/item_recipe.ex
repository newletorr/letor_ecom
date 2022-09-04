defmodule LetorEcom.Delicacies.ItemRecipe do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Delicacies.Recipe

  schema "item_recipes" do
    belongs_to(:item, Item)
    belongs_to(:recipe, Recipe)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_recipe, attrs) do
    item_recipe
    |> cast(attrs, [:item_id, :recipe_id])
    |> validate_required([:item_id, :recipe_id])
    |> assoc_constraint(:item)
    |> assoc_constraint(:recipe)
  end
end
