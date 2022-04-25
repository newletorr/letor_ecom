defmodule LetorEcom.DelicaciesTest do
  use LetorEcom.DataCase

  alias LetorEcom.Delicacies

  describe "recipe_classes" do
    alias LetorEcom.Delicacies.RecipeClass

    import LetorEcom.DelicaciesFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_recipe_classes/0 returns all recipe_classes" do
      recipe_class = recipe_class_fixture()
      assert Delicacies.list_recipe_classes() == [recipe_class]
    end

    test "get_recipe_class!/1 returns the recipe_class with given id" do
      recipe_class = recipe_class_fixture()
      assert Delicacies.get_recipe_class!(recipe_class.id) == recipe_class
    end

    test "create_recipe_class/1 with valid data creates a recipe_class" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %RecipeClass{} = recipe_class} = Delicacies.create_recipe_class(valid_attrs)
      assert recipe_class.description == "some description"
      assert recipe_class.name == "some name"
    end

    test "create_recipe_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Delicacies.create_recipe_class(@invalid_attrs)
    end

    test "update_recipe_class/2 with valid data updates the recipe_class" do
      recipe_class = recipe_class_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %RecipeClass{} = recipe_class} =
               Delicacies.update_recipe_class(recipe_class, update_attrs)

      assert recipe_class.description == "some updated description"
      assert recipe_class.name == "some updated name"
    end

    test "update_recipe_class/2 with invalid data returns error changeset" do
      recipe_class = recipe_class_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Delicacies.update_recipe_class(recipe_class, @invalid_attrs)

      assert recipe_class == Delicacies.get_recipe_class!(recipe_class.id)
    end

    test "delete_recipe_class/1 deletes the recipe_class" do
      recipe_class = recipe_class_fixture()
      assert {:ok, %RecipeClass{}} = Delicacies.delete_recipe_class(recipe_class)
      assert_raise Ecto.NoResultsError, fn -> Delicacies.get_recipe_class!(recipe_class.id) end
    end

    test "change_recipe_class/1 returns a recipe_class changeset" do
      recipe_class = recipe_class_fixture()
      assert %Ecto.Changeset{} = Delicacies.change_recipe_class(recipe_class)
    end
  end

  describe "recipes" do
    alias LetorEcom.Delicacies.Recipe

    import LetorEcom.DelicaciesFixtures

    @invalid_attrs %{
      description: nil,
      directions: nil,
      image1_url: nil,
      image2_url: nil,
      image3_url: nil,
      meal_type: nil,
      name: nil,
      special: nil,
      video: nil
    }

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Delicacies.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Delicacies.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{
        description: "some description",
        directions: "some directions",
        image1_url: "some image1_url",
        image2_url: "some image2_url",
        image3_url: "some image3_url",
        meal_type: "some meal_type",
        name: "some name",
        special: "some special",
        video: "some video"
      }

      assert {:ok, %Recipe{} = recipe} = Delicacies.create_recipe(valid_attrs)
      assert recipe.description == "some description"
      assert recipe.directions == "some directions"
      assert recipe.image1_url == "some image1_url"
      assert recipe.image2_url == "some image2_url"
      assert recipe.image3_url == "some image3_url"
      assert recipe.meal_type == "some meal_type"
      assert recipe.name == "some name"
      assert recipe.special == "some special"
      assert recipe.video == "some video"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Delicacies.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()

      update_attrs = %{
        description: "some updated description",
        directions: "some updated directions",
        image1_url: "some updated image1_url",
        image2_url: "some updated image2_url",
        image3_url: "some updated image3_url",
        meal_type: "some updated meal_type",
        name: "some updated name",
        special: "some updated special",
        video: "some updated video"
      }

      assert {:ok, %Recipe{} = recipe} = Delicacies.update_recipe(recipe, update_attrs)
      assert recipe.description == "some updated description"
      assert recipe.directions == "some updated directions"
      assert recipe.image1_url == "some updated image1_url"
      assert recipe.image2_url == "some updated image2_url"
      assert recipe.image3_url == "some updated image3_url"
      assert recipe.meal_type == "some updated meal_type"
      assert recipe.name == "some updated name"
      assert recipe.special == "some updated special"
      assert recipe.video == "some updated video"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Delicacies.update_recipe(recipe, @invalid_attrs)
      assert recipe == Delicacies.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Delicacies.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Delicacies.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Delicacies.change_recipe(recipe)
    end
  end

  describe "item_recipes" do
    alias LetorEcom.Delicacies.ItemRecipe

    import LetorEcom.DelicaciesFixtures

    @invalid_attrs %{}

    test "list_item_recipes/0 returns all item_recipes" do
      item_recipe = item_recipe_fixture()
      assert Delicacies.list_item_recipes() == [item_recipe]
    end

    test "get_item_recipe!/1 returns the item_recipe with given id" do
      item_recipe = item_recipe_fixture()
      assert Delicacies.get_item_recipe!(item_recipe.id) == item_recipe
    end

    test "create_item_recipe/1 with valid data creates a item_recipe" do
      valid_attrs = %{}

      assert {:ok, %ItemRecipe{} = item_recipe} = Delicacies.create_item_recipe(valid_attrs)
    end

    test "create_item_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Delicacies.create_item_recipe(@invalid_attrs)
    end

    test "update_item_recipe/2 with valid data updates the item_recipe" do
      item_recipe = item_recipe_fixture()
      update_attrs = %{}

      assert {:ok, %ItemRecipe{} = item_recipe} =
               Delicacies.update_item_recipe(item_recipe, update_attrs)
    end

    test "update_item_recipe/2 with invalid data returns error changeset" do
      item_recipe = item_recipe_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Delicacies.update_item_recipe(item_recipe, @invalid_attrs)

      assert item_recipe == Delicacies.get_item_recipe!(item_recipe.id)
    end

    test "delete_item_recipe/1 deletes the item_recipe" do
      item_recipe = item_recipe_fixture()
      assert {:ok, %ItemRecipe{}} = Delicacies.delete_item_recipe(item_recipe)
      assert_raise Ecto.NoResultsError, fn -> Delicacies.get_item_recipe!(item_recipe.id) end
    end

    test "change_item_recipe/1 returns a item_recipe changeset" do
      item_recipe = item_recipe_fixture()
      assert %Ecto.Changeset{} = Delicacies.change_item_recipe(item_recipe)
    end
  end
end
