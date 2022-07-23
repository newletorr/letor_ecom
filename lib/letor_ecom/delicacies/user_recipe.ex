defmodule LetorEcom.Delicacies.UserRecipe do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.Delicacies.Recipe

  schema "user_recipes" do
    belongs_to(:recipe, Recipe)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_recipe, attrs) do
    user_recipe
    |> cast(attrs, [:recipe_id, :user_id])
    |> validate_required([:recipe_id])
    |> unique_constraint(:recipe_id, name: :user_recipes_recipe_id_user_id_ix)
    |> assoc_constraint(:recipe)
    |> assoc_constraint(:user)
  end
end
