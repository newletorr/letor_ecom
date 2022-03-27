defmodule LetorEcom.CatalogueTest do
  use LetorEcom.DataCase

  alias LetorEcom.Catalogue

  describe "item_categories" do
    alias LetorEcom.Catalogue.ItemCategory

    import LetorEcom.CatalogueFixtures
    import LetorEcom.CentresFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_item_categories/0 returns all item_categories" do
      item_category = item_category_fixture()
      assert Catalogue.list_item_categories() == [item_category]
    end

    test "get_item_category!/1 returns the item_category with given id" do
      item_category = item_category_fixture()
      assert Catalogue.get_item_category!(item_category.id) == item_category
    end

    test "create_item_category/1 with valid data creates a item_category" do
      pickup_centre = pickup_centre_fixture()

      valid_attrs = %{
        description: "some description",
        name: "some name",
        pickup_centre_id: pickup_centre.id
      }

      assert {:ok, %ItemCategory{} = item_category} = Catalogue.create_item_category(valid_attrs)
      assert item_category.description == "some description"
      assert item_category.name == "some name"
    end

    test "create_item_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_category(@invalid_attrs)
    end

    test "update_item_category/2 with valid data updates the item_category" do
      item_category = item_category_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %ItemCategory{} = item_category} =
               Catalogue.update_item_category(item_category, update_attrs)

      assert item_category.description == "some updated description"
      assert item_category.name == "some updated name"
    end

    test "update_item_category/2 with invalid data returns error changeset" do
      item_category = item_category_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalogue.update_item_category(item_category, @invalid_attrs)

      assert item_category == Catalogue.get_item_category!(item_category.id)
    end

    test "delete_item_category/1 deletes the item_category" do
      item_category = item_category_fixture()
      assert {:ok, %ItemCategory{}} = Catalogue.delete_item_category(item_category)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_item_category!(item_category.id) end
    end
  end

  describe "item_subcategories" do
    alias LetorEcom.Catalogue.ItemSubcategory

    import LetorEcom.CatalogueFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_item_subcategories/0 returns all item_subcategories" do
      item_subcategory = item_subcategory_fixture()
      assert Catalogue.list_item_subcategories() == [item_subcategory]
    end

    test "get_item_subcategory!/1 returns the item_subcategory with given id" do
      item_subcategory = item_subcategory_fixture()
      assert Catalogue.get_item_subcategory!(item_subcategory.id) == item_subcategory
    end

    test "create_item_subcategory/1 with valid data creates a item_subcategory" do
      item_category = item_category_fixture()

      valid_attrs = %{
        description: "some description",
        name: "some name",
        item_category_id: item_category.id
      }

      assert {:ok, %ItemSubcategory{} = item_subcategory} =
               Catalogue.create_item_subcategory(valid_attrs)

      assert item_subcategory.description == "some description"
      assert item_subcategory.name == "some name"
    end

    test "create_item_subcategory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_subcategory(@invalid_attrs)
    end

    test "update_item_subcategory/2 with valid data updates the item_subcategory" do
      item_subcategory = item_subcategory_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %ItemSubcategory{} = item_subcategory} =
               Catalogue.update_item_subcategory(item_subcategory, update_attrs)

      assert item_subcategory.description == "some updated description"
      assert item_subcategory.name == "some updated name"
    end

    test "update_item_subcategory/2 with invalid data returns error changeset" do
      item_subcategory = item_subcategory_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalogue.update_item_subcategory(item_subcategory, @invalid_attrs)

      assert item_subcategory == Catalogue.get_item_subcategory!(item_subcategory.id)
    end

    test "delete_item_subcategory/1 deletes the item_subcategory" do
      item_subcategory = item_subcategory_fixture()
      assert {:ok, %ItemSubcategory{}} = Catalogue.delete_item_subcategory(item_subcategory)

      assert_raise Ecto.NoResultsError, fn ->
        Catalogue.get_item_subcategory!(item_subcategory.id)
      end
    end
  end

  describe "sku" do
    alias LetorEcom.Catalogue.Sku

    import LetorEcom.CatalogueFixtures
    import LetorEcom.CentresFixtures

    @invalid_attrs %{code: nil, item_name: nil}

    test "list_sku/0 returns all sku" do
      sku = sku_fixture()
      assert Catalogue.list_sku() == [sku]
    end

    test "get_sku!/1 returns the sku with given id" do
      sku = sku_fixture()
      assert Catalogue.get_sku!(sku.id) == sku
    end

    test "create_sku/1 with valid data creates a sku" do
      pickup_centre = pickup_centre_fixture()

      valid_attrs = %{
        code: "some code",
        item_name: "some item_name",
        pickup_centre_id: pickup_centre.id
      }

      assert {:ok, %Sku{} = sku} = Catalogue.create_sku(valid_attrs)
      assert sku.code == "some code"
      assert sku.item_name == "some item_name"
    end

    test "create_sku/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_sku(@invalid_attrs)
    end

    test "update_sku/2 with valid data updates the sku" do
      sku = sku_fixture()
      update_attrs = %{code: "some updated code", item_name: "some updated item_name"}

      assert {:ok, %Sku{} = sku} = Catalogue.update_sku(sku, update_attrs)
      assert sku.code == "some updated code"
      assert sku.item_name == "some updated item_name"
    end

    test "update_sku/2 with invalid data returns error changeset" do
      sku = sku_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_sku(sku, @invalid_attrs)
      assert sku == Catalogue.get_sku!(sku.id)
    end

    test "delete_sku/1 deletes the sku" do
      sku = sku_fixture()
      assert {:ok, %Sku{}} = Catalogue.delete_sku(sku)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_sku!(sku.id) end
    end
  end
end
