defmodule LetorEcom.Delicacies.RecipeClass do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre

  schema "recipe_classes" do
    field :description, :string
    field :name, :string
    belongs_to(:pickup_centre, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_class, attrs) do
    recipe_class
    |> cast(attrs, [:pickup_centre_id, :name, :description])
    |> validate_required([:name, :description])
    |> assoc_constraint(:pickup_centre)
  end
end
