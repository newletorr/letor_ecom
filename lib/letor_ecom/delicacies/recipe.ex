defmodule LetorEcom.Delicacies.Recipe do
  use LetorEcom.SchemaHelper

  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Delicacies.{ItemRecipe, RecipeClass}

  schema "recipes" do
    many_to_many(:items, Item, join_through: ItemRecipe)
    field :description, :string, read_after_writes: true
    field :directions, :string, read_after_writes: true
    field :image1_url, :string, read_after_writes: true
    field :image2_url, :string, read_after_writes: true
    field :image3_url, :string, read_after_writes: true
    field :meal_type, :string, read_after_writes: true
    field :name, :string, read_after_writes: true
    field :special, :boolean, read_after_writes: true
    field :video, :string, read_after_writes: true
    belongs_to(:recipe_class, RecipeClass)
    has_many(:item_recipes, ItemRecipe)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [
      :recipe_class_id,
      :description,
      :name,
      :directions,
      :image1_url,
      :image2_url,
      :image3_url,
      :video,
      :special,
      :meal_type
    ])
    |> validate_required([
      :recipe_class_id,
      :description,
      :name,
      :directions,
      :image1_url,
      :meal_type
    ])
    |> foreign_key_constraint(:recipe_class_id, name: :recipes_recipe_class_id_fkey)
  end
end
