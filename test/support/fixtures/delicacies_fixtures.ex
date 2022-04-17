defmodule LetorEcom.DelicaciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Delicacies` context.
  """

  @doc """
  Generate a recipe_class.
  """
  def recipe_class_fixture(attrs \\ %{}) do
    {:ok, recipe_class} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> LetorEcom.Delicacies.create_recipe_class()

    recipe_class
  end

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        description: "some description",
        directions: "some directions",
        image1_url: "some image1_url",
        image2_url: "some image2_url",
        image3_url: "some image3_url",
        meal_type: "some meal_type",
        name: "some name",
        special: "some special",
        video: "some video"
      })
      |> LetorEcom.Delicacies.create_recipe()

    recipe
  end

  @doc """
  Generate a item_recipe.
  """
  def item_recipe_fixture(attrs \\ %{}) do
    {:ok, item_recipe} =
      attrs
      |> Enum.into(%{

      })
      |> LetorEcom.Delicacies.create_item_recipe()

    item_recipe
  end
end
