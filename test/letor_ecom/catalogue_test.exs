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

  describe "items" do
    alias LetorEcom.Catalogue.Item

    import LetorEcom.CatalogueFixtures

    @invalid_attrs %{
      actual_price: nil,
      availability_time: nil,
      available_quantity: nil,
      barcode: nil,
      brand_name: nil,
      bulk: nil,
      customization_allowed: nil,
      description: nil,
      details: nil,
      expired: nil,
      group_buying_price: nil,
      item_code: nil,
      main_price: nil,
      name: nil,
      out_of_stock: nil,
      package_size: nil,
      preparation_time: nil,
      promo_price: nil,
      qa_cleared: nil,
      qr_code: nil,
      regional_name: nil,
      size: nil,
      third_party_item: nil,
      type: nil
    }

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Catalogue.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Catalogue.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{
        actual_price: "120.5",
        availability_time: "some availability_time",
        available_quantity: 42,
        barcode: "some barcode",
        brand_name: "some brand_name",
        bulk: true,
        customization_allowed: true,
        description: "some description",
        details: "some details",
        expired: true,
        group_buying_price: "120.5",
        item_code: "some item_code",
        main_price: "120.5",
        name: "some name",
        out_of_stock: true,
        package_size: "some package_size",
        preparation_time: "some preparation_time",
        promo_price: "120.5",
        qa_cleared: true,
        qr_code: "some qr_code",
        regional_name: "some regional_name",
        size: 42,
        third_party_item: "some third_party_item",
        type: "some type"
      }

      assert {:ok, %Item{} = item} = Catalogue.create_item(valid_attrs)
      assert item.actual_price == Decimal.new("120.5")
      assert item.availability_time == "some availability_time"
      assert item.available_quantity == 42
      assert item.barcode == "some barcode"
      assert item.brand_name == "some brand_name"
      assert item.bulk == true
      assert item.customization_allowed == true
      assert item.description == "some description"
      assert item.details == "some details"
      assert item.expired == true
      assert item.group_buying_price == Decimal.new("120.5")
      assert item.item_code == "some item_code"
      assert item.main_price == Decimal.new("120.5")
      assert item.name == "some name"
      assert item.out_of_stock == true
      assert item.package_size == "some package_size"
      assert item.preparation_time == "some preparation_time"
      assert item.promo_price == Decimal.new("120.5")
      assert item.qa_cleared == true
      assert item.qr_code == "some qr_code"
      assert item.regional_name == "some regional_name"
      assert item.size == 42
      assert item.third_party_item == "some third_party_item"
      assert item.type == "some type"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()

      update_attrs = %{
        actual_price: "456.7",
        availability_time: "some updated availability_time",
        available_quantity: 43,
        barcode: "some updated barcode",
        brand_name: "some updated brand_name",
        bulk: false,
        customization_allowed: false,
        description: "some updated description",
        details: "some updated details",
        expired: false,
        group_buying_price: "456.7",
        item_code: "some updated item_code",
        main_price: "456.7",
        name: "some updated name",
        out_of_stock: false,
        package_size: "some updated package_size",
        preparation_time: "some updated preparation_time",
        promo_price: "456.7",
        qa_cleared: false,
        qr_code: "some updated qr_code",
        regional_name: "some updated regional_name",
        size: 43,
        third_party_item: "some updated third_party_item",
        type: "some updated type"
      }

      assert {:ok, %Item{} = item} = Catalogue.update_item(item, update_attrs)
      assert item.actual_price == Decimal.new("456.7")
      assert item.availability_time == "some updated availability_time"
      assert item.available_quantity == 43
      assert item.barcode == "some updated barcode"
      assert item.brand_name == "some updated brand_name"
      assert item.bulk == false
      assert item.customization_allowed == false
      assert item.description == "some updated description"
      assert item.details == "some updated details"
      assert item.expired == false
      assert item.group_buying_price == Decimal.new("456.7")
      assert item.item_code == "some updated item_code"
      assert item.main_price == Decimal.new("456.7")
      assert item.name == "some updated name"
      assert item.out_of_stock == false
      assert item.package_size == "some updated package_size"
      assert item.preparation_time == "some updated preparation_time"
      assert item.promo_price == Decimal.new("456.7")
      assert item.qa_cleared == false
      assert item.qr_code == "some updated qr_code"
      assert item.regional_name == "some updated regional_name"
      assert item.size == 43
      assert item.third_party_item == "some updated third_party_item"
      assert item.type == "some updated type"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_item(item, @invalid_attrs)
      assert item == Catalogue.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Catalogue.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_item!(item.id) end
    end
  end

  describe "item_images" do
    alias LetorEcom.Catalogue.ItemImage

    import LetorEcom.CatalogueFixtures

    @invalid_attrs %{
      item_image1: nil,
      item_image2: nil,
      item_image3: nil,
      item_image4: nil,
      item_name: nil,
      video_url: nil
    }

    test "list_item_images/0 returns all item_images" do
      item_image = item_image_fixture()
      assert Catalogue.list_item_images() == [item_image]
    end

    test "get_item_image!/1 returns the item_image with given id" do
      item_image = item_image_fixture()
      assert Catalogue.get_item_image!(item_image.id) == item_image
    end

    test "create_item_image/1 with valid data creates a item_image" do
      valid_attrs = %{
        item_image1: "some item_image1",
        item_image2: "some item_image2",
        item_image3: "some item_image3",
        item_image4: "some item_image4",
        item_name: "some item_name",
        video_url: "some video_url"
      }

      assert {:ok, %ItemImage{} = item_image} = Catalogue.create_item_image(valid_attrs)
      assert item_image.item_image1 == "some item_image1"
      assert item_image.item_image2 == "some item_image2"
      assert item_image.item_image3 == "some item_image3"
      assert item_image.item_image4 == "some item_image4"
      assert item_image.item_name == "some item_name"
      assert item_image.video_url == "some video_url"
    end

    test "create_item_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_image(@invalid_attrs)
    end

    test "update_item_image/2 with valid data updates the item_image" do
      item_image = item_image_fixture()

      update_attrs = %{
        item_image1: "some updated item_image1",
        item_image2: "some updated item_image2",
        item_image3: "some updated item_image3",
        item_image4: "some updated item_image4",
        item_name: "some updated item_name",
        video_url: "some updated video_url"
      }

      assert {:ok, %ItemImage{} = item_image} =
               Catalogue.update_item_image(item_image, update_attrs)

      assert item_image.item_image1 == "some updated item_image1"
      assert item_image.item_image2 == "some updated item_image2"
      assert item_image.item_image3 == "some updated item_image3"
      assert item_image.item_image4 == "some updated item_image4"
      assert item_image.item_name == "some updated item_name"
      assert item_image.video_url == "some updated video_url"
    end

    test "update_item_image/2 with invalid data returns error changeset" do
      item_image = item_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_item_image(item_image, @invalid_attrs)
      assert item_image == Catalogue.get_item_image!(item_image.id)
    end

    test "delete_item_image/1 deletes the item_image" do
      item_image = item_image_fixture()
      assert {:ok, %ItemImage{}} = Catalogue.delete_item_image(item_image)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_item_image!(item_image.id) end
    end
  end

  describe "item_tag" do
    alias LetorEcom.Catalogue.ItemTag

    import LetorEcom.CatalogueFixtures

    @invalid_attrs %{class: nil, description: nil, name: nil}

    test "list_item_tag/0 returns all item_tag" do
      item_tag = item_tag_fixture()
      assert Catalogue.list_item_tag() == [item_tag]
    end

    test "get_item_tag!/1 returns the item_tag with given id" do
      item_tag = item_tag_fixture()
      assert Catalogue.get_item_tag!(item_tag.id) == item_tag
    end

    test "create_item_tag/1 with valid data creates a item_tag" do
      valid_attrs = %{class: "some class", description: "some description", name: "some name"}

      assert {:ok, %ItemTag{} = item_tag} = Catalogue.create_item_tag(valid_attrs)
      assert item_tag.class == "some class"
      assert item_tag.description == "some description"
      assert item_tag.name == "some name"
    end

    test "create_item_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_tag(@invalid_attrs)
    end

    test "update_item_tag/2 with valid data updates the item_tag" do
      item_tag = item_tag_fixture()

      update_attrs = %{
        class: "some updated class",
        description: "some updated description",
        name: "some updated name"
      }

      assert {:ok, %ItemTag{} = item_tag} = Catalogue.update_item_tag(item_tag, update_attrs)
      assert item_tag.class == "some updated class"
      assert item_tag.description == "some updated description"
      assert item_tag.name == "some updated name"
    end

    test "update_item_tag/2 with invalid data returns error changeset" do
      item_tag = item_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_item_tag(item_tag, @invalid_attrs)
      assert item_tag == Catalogue.get_item_tag!(item_tag.id)
    end

    test "delete_item_tag/1 deletes the item_tag" do
      item_tag = item_tag_fixture()
      assert {:ok, %ItemTag{}} = Catalogue.delete_item_tag(item_tag)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_item_tag!(item_tag.id) end
    end

    test "change_item_tag/1 returns a item_tag changeset" do
      item_tag = item_tag_fixture()
      assert %Ecto.Changeset{} = Catalogue.change_item_tag(item_tag)
    end
  end

  describe "item_taggings" do
    alias LetorEcom.Catalogue.ItemTagging

    import LetorEcom.CatalogueFixtures

    @invalid_attrs %{}

    test "list_item_taggings/0 returns all item_taggings" do
      item_tagging = item_tagging_fixture()
      assert Catalogue.list_item_taggings() == [item_tagging]
    end

    test "get_item_tagging!/1 returns the item_tagging with given id" do
      item_tagging = item_tagging_fixture()
      assert Catalogue.get_item_tagging!(item_tagging.id) == item_tagging
    end

    test "create_item_tagging/1 with valid data creates a item_tagging" do
      valid_attrs = %{}

      assert {:ok, %ItemTagging{} = item_tagging} = Catalogue.create_item_tagging(valid_attrs)
    end

    test "create_item_tagging/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_tagging(@invalid_attrs)
    end

    test "update_item_tagging/2 with valid data updates the item_tagging" do
      item_tagging = item_tagging_fixture()
      update_attrs = %{}

      assert {:ok, %ItemTagging{} = item_tagging} =
               Catalogue.update_item_tagging(item_tagging, update_attrs)
    end

    test "update_item_tagging/2 with invalid data returns error changeset" do
      item_tagging = item_tagging_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalogue.update_item_tagging(item_tagging, @invalid_attrs)

      assert item_tagging == Catalogue.get_item_tagging!(item_tagging.id)
    end

    test "delete_item_tagging/1 deletes the item_tagging" do
      item_tagging = item_tagging_fixture()
      assert {:ok, %ItemTagging{}} = Catalogue.delete_item_tagging(item_tagging)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_item_tagging!(item_tagging.id) end
    end

    test "change_item_tagging/1 returns a item_tagging changeset" do
      item_tagging = item_tagging_fixture()
      assert %Ecto.Changeset{} = Catalogue.change_item_tagging(item_tagging)
    end
  end
end
