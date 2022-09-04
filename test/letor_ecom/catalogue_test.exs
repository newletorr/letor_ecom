defmodule LetorEcom.CatalogueTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory
  alias LetorEcom.Catalogue
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.Control.EcommerceControl
  alias LetorEcom.Repo

  describe "item_categories" do
    alias LetorEcom.Catalogue.ItemCategory

    @invalid_attrs %{description: nil, name: nil, pickup_centre_id: nil}

    test "create_item_category/1 with valid data creates a item_category" do
      name = "#{System.unique_integer()}name"
      pickup_centre = pickup_centre_fixture()

      valid_attrs = %{
        description: "some description",
        name: name,
        pickup_centre_id: pickup_centre.id
      }

      assert {:ok, %ItemCategory{} = item_category} = Catalogue.create_item_category(valid_attrs)
      assert item_category.description == "some description"
      assert item_category.name == name
    end

    test "create_item_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_category(@invalid_attrs)
    end

    test "update_item_category/2 with valid data updates the item_category" do
      ecommerce_control = ecommerce_control_fixture() #build(:ecommerce_control)
      pickup_centre = pickup_centre_fixture() #insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      item_category = item_category_fixture() #insert!(:item_category, pickup_centre: pickup_centre)
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %ItemCategory{} = item_category} =
               Catalogue.update_item_category(item_category, update_attrs)

      assert item_category.description == "some updated description"
      assert item_category.name == "some updated name"
    end

    # test "update_item_category/2 with invalid data returns error changeset" do
    # item_category = Repo.all(ItemCategory) |> List.first()

    # assert {:error, %Ecto.Changeset{}} =
    #        Catalogue.update_item_category(item_category, @invalid_attrs)
    # end

    # test "delete_item_category/1 deletes the item_category" do
    # item_category = Repo.all(ItemCategory) |> List.first()
    # assert {:ok, %ItemCategory{}} = Catalogue.delete_item_category(item_category)
    # end
  end

  describe "item_subcategories" do
    alias LetorEcom.Catalogue.{ItemCategory, ItemSubcategory}

    @invalid_attrs %{description: nil, name: nil}

    test "create_item_subcategory/1 with valid data creates a item_subcategory" do
      name = "#{System.unique_integer()}some name"
      item_category = item_category_fixture()

      valid_attrs = %{
        description: "some description",
        name: name,
        item_category_id: item_category.id
      }

      assert {:ok, %ItemSubcategory{} = item_subcategory} =
               Catalogue.create_item_subcategory(valid_attrs)

      assert item_subcategory.description == "some description"
      assert item_subcategory.name == name
    end

    test "create_item_subcategory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_subcategory(@invalid_attrs)
    end

    test "update_item_subcategory/2 with valid data updates the item_subcategory" do
      item_category = item_category_fixture() #build(:item_category)
      item_subcategory = item_subcategory_fixture()#insert!(:item_subcategory, item_category: item_category)
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %ItemSubcategory{} = item_subcategory} =
               Catalogue.update_item_subcategory(item_subcategory, update_attrs)

      assert item_subcategory.description == "some updated description"
      assert item_subcategory.name == "some updated name"
    end

    # test "update_item_subcategory/2 with invalid data returns error changeset" do
    #  item_subcategory = Repo.all(ItemSubcategory) |> List.first()

    # assert {:error, %Ecto.Changeset{}} =
    #         Catalogue.update_item_subcategory(item_subcategory, @invalid_attrs)
    # end

    # test "delete_item_subcategory/1 deletes the item_subcategory" do
    #  item_subcategory = Repo.all(ItemSubcategory) |> List.first()
    # assert {:ok, %ItemSubcategory{}} = Catalogue.delete_item_subcategory(item_subcategory)
    # end
  end

  describe "sku" do
    alias LetorEcom.Catalogue.Sku

    alias LetorEcom.Catalogue.{Item, ItemImage, ItemSubcategory, ItemTag}
    alias LetorEcom.Centres.InventoryLocation

    @invalid_attrs %{
      barcode: nil,
      details: nil,
      item_subcategory_id: nil,
      type: nil,
      main_price: nil,
      package_size: nil,
      item_image_id: nil,
      pickup_centre_id: nil,
      inventory_location_id: nil,
      description: nil,
      max_internal_quantity: nil,
      max_external_quantity: nil,
      name: nil,
      reorder_level: nil,
      internal_quantity: nil,
      external_quantity: nil,
      internal_quantity_uom: nil,
      external_quantity_uom: nil,
      buy_price: nil,
      sales_price: nil,
      status: nil,
      expiry_date: nil
    }

    test "create_sku/1 with valid data creates a sku" do
      pickup_centre = pickup_centre_fixture()
      item_subcategory = item_subcategory_fixture()
      item_image = item_image_fixture()
      inventory_location = inventory_location_fixture()
      item_tag = item_tag_fixture()

      valid_attrs = %{
        item_subcategory_id: item_subcategory.id,
        item_tag_id: item_tag.id,
        type: "Groceries",
        package_uom: "Sachet",
        item_image_id: item_image.id,
        pickup_centre_id: pickup_centre.id,
        inventory_location_id: inventory_location.id,
        description: "Itambe Sachet Liquid Milk",
        max_bulk_quantity: 30,
        name: "Itambe Milk1",
        re_order_level: 5,
        sales_unit_quantity: 80,
        bulk_quantity: 5,
        sales_unit_quantity_uom: "Packet",
        bulk_quantity_uom: "Carton",
        buy_price: 150,
        unit_sales_price: 250,
        bulk_sales_price: 3000,
        status: "available",
        expiry_date: ~D[2023-02-03]
      }

      assert {:ok, %{sku: sku}} = Catalogue.create_sku_inventory_and_item(valid_attrs)
      assert sku.name == "Itambe Milk1"
    end

    # test "create_sku/1 with invalid data returns error changeset" do
    #  assert {:error, :sku, _changeset, _} =
    #          Catalogue.create_sku_inventory_and_item(@invalid_attrs)
    # end

    test "update_sku/2 with valid data updates the sku" do
      ecommerce_control = ecommerce_control_fixture()#build(:ecommerce_control)
      pickup_centre = pickup_centre_fixture()#insert!(:pickup_centre, ecommerce_control: ecommerce_control)

      sku = sku_fixture()#insert!(:sku, pickup_centre: pickup_centre)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Sku{} = sku} = Catalogue.update_sku(sku, update_attrs)
      assert sku.name == "some updated name"
    end

    # test "update_sku/2 with invalid data returns error changeset" do
    # sku = Repo.all(Sku) |> List.first()
    # assert {:error, %Ecto.Changeset{}} = Catalogue.update_sku(sku, @invalid_attrs)
    # end

    test "delete_sku/1 deletes the sku" do
      #ecommerce_control = ecommerce_control_fixture()
      #pickup_centre = pickup_centre_fixture()
      sku = sku_fixture()
      assert {:ok, %Sku{}} = Catalogue.delete_sku(sku)
    end
  end

  describe "items" do
    alias LetorEcom.Catalogue.{Item, ItemImage, ItemSubcategory, ItemTag}
    alias LetorEcom.Centres.InventoryLocation

    @invalid_attrs %{
      barcode: nil,
      details: nil,
      item_subcategory_id: nil,
      type: nil,
      main_price: nil,
      package_size: nil,
      item_image_id: nil,
      pickup_centre_id: nil,
      inventory_location_id: nil,
      description: nil,
      max_internal_quantity: nil,
      max_external_quantity: nil,
      name: nil,
      reorder_level: nil,
      internal_quantity: nil,
      external_quantity: nil,
      internal_quantity_uom: nil,
      external_quantity_uom: nil,
      buy_price: nil,
      sales_price: nil,
      status: nil,
      expiry_date: nil
    }

    test "create_item/1 with valid data creates a item" do
      pickup_centre = pickup_centre_fixture()
      item_subcategory = item_subcategory_fixture()
      item_image = item_image_fixture()
      inventory_location = inventory_location_fixture()
      item_tag = item_tag_fixture()

      valid_attrs = %{
        item_subcategory_id: item_subcategory.id,
        item_tag_id: item_tag.id,
        type: "Groceries",
        package_uom: "Hand",
        details: "Fresh Banana sourced from the land of Ekpeye",
        item_image_id: item_image.id,
        pickup_centre_id: pickup_centre.id,
        inventory_location_id: inventory_location.id,
        description: "Ripe Fresh Nigerian Bananas",
        max_bulk_quantity: 30,
        name: "Banana",
        re_order_level: 5,
        sales_unit_quantity: 20,
        bulk_quantity: 5,
        sales_unit_quantity_uom: "Hand",
        bulk_quantity_uom: "Bunch",
        buy_price: 500,
        unit_sales_price: 800,
        bulk_sales_price: 3000,
        #re_order_level: 2,
        #status: "available",
        expired: true
      }

      assert {:ok, %{item: item}} = Catalogue.create_sku_inventory_and_item(valid_attrs)
      assert item.type == "Groceries"
      assert item.package_uom == "Hand"
      assert item.details == "Fresh Banana sourced from the land of Ekpeye"
      assert item.description == "Ripe Fresh Nigerian Bananas"
      #assert item.max_bulk_quantity == 30
      assert item.name == "Banana"
      #assert item.re_order_level == 5
      #assert item.sales_unit_quantity == 20
      #assert item.bulk_quantity == 5
      #assert item.sales_unit_quantity_uom == "Hand"
      #assert item.bulk_quantity_uom == "Bunch"
      #assert item.buy_price == 500
      #assert item.unit_sales_price == 800
      #assert item.bulk_sales_price == 3000
      #assert item.re_order_level == 2
      #assert item.status == "available"
      assert item.expired == true
    end

    #test "create_item/1 with invalid data returns error changeset" do
     # assert {:error, :item, _changeset, _}
      #Catalogue.create_sku_inventory_and_item(@invalid_attrs)
    #end

    test "update_item/2 with valid data updates the item" do
      item_subcategory = item_subcategory_fixture()#build(:item_subcategory)
      item = item_fixture()#insert!(:item, item_subcategory: item_subcategory)

      update_attrs = %{
        actual_price: Decimal.new("120.5"),
        availability_time: "some updated availability_time",
        available_quantity: 43,
        barcode: "some updated barcode",
        brand_name: "some updated brand_name",
        bulk: false,
        customization_allowed: false,
        description: "some updated description",
        details: "some updated details",
        expired: false,
        group_buying_price: Decimal.new("120.5"),
        item_code: "some updated item_code",
        main_price: Decimal.new("120.5"),
        name: "some updated name",
        out_of_stock: false,
        package_uom: "some updated package_uom",
        preparation_time: "some updated preparation_time",
        promo_price: Decimal.new("120.5"),
        qa_cleared: false,
        regional_name: "some updated regional_name",
        size: 43,
        third_party_item: "some updated third_party_item",
        type: "some updated type"
      }

      assert {:ok, %Item{} = item} = Catalogue.update_item(item, update_attrs)
      assert item.actual_price == Decimal.new("120.5")
      assert item.availability_time == "some updated availability_time"
      assert item.available_quantity == 43
      assert item.barcode == "some updated barcode"
      assert item.brand_name == "some updated brand_name"
      assert item.bulk == false
      assert item.customization_allowed == false
      assert item.description == "some updated description"
      assert item.details == "some updated details"
      assert item.expired == false
      assert item.group_buying_price == Decimal.new("120.5")
      assert item.item_code == "some updated item_code"
      assert item.main_price == Decimal.new("120.5")
      assert item.name == "some updated name"
      assert item.out_of_stock == false
      assert item.package_uom == "some updated package_uom"
      assert item.preparation_time == "some updated preparation_time"
      assert item.promo_price == Decimal.new("120.5")
      assert item.qa_cleared == false
      assert item.regional_name == "some updated regional_name"
      assert item.size == 43
      assert item.third_party_item == "some updated third_party_item"
      assert item.type == "some updated type"
    end

    # test "update_item/2 with invalid data returns error changeset" do
    # item = Repo.all(Item) |> List.first
    # assert {:error, %Ecto.Changeset{}} = Catalogue.update_item(item, @invalid_attrs)
    # end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Catalogue.delete_item(item)
    end
  end

  describe "item_images" do
    alias LetorEcom.Catalogue.ItemImage
    alias LetorEcom.Control.EcommerceControl

    @invalid_attrs %{
      item_name: "Indomie",
      video_url: nil,
      ecommerce_control_id: nil
    }

    test "create_item_image/1 with valid data creates a item_image" do
      item_image = item_image_fixture()
      ecommerce_control = ecommerce_control_fixture()

      valid_attrs = %{
        item_name: "some item_name",
        video_url: "some video_url",
        item_image1: "some item_image1",
        item_image2: "some item_image2",
        item_image3: "some item_image3",
        item_image4: "some item_image4",
        ecommerce_control_id: ecommerce_control.id
      }

      assert {:ok, %{item_image: item_image}} = Catalogue.create_item_image(valid_attrs)
      assert item_image.item_name == "some item_name"
      assert item_image.video_url == "some video_url"
      assert item_image.item_image1 == "some item_image1"
      assert item_image.item_image2 == "some item_image2"
      assert item_image.item_image3 == "some item_image3"
      assert item_image.item_image4 == "some item_image4"
      assert item_image.ecommerce_control_id == ecommerce_control.id
    end

    test "create_item_image/1 with invalid data returns error changeset" do
      assert {:error, :item_image, _changeset, _} = Catalogue.create_item_image(@invalid_attrs)
    end

    test "update_item_image/2 with valid data updates the item_image" do
      ecommerce_control = ecommerce_control_fixture()#build(:ecommerce_control)
      item_image = item_image_fixture()#insert!(:item_image, ecommerce_control: ecommerce_control)

      update_attrs = %{
        item_name: "some updated item_name",
        video_url: "some updated video_url"
      }

      assert {:ok, %ItemImage{} = item_image} =
               Catalogue.update_item_image(item_image, update_attrs)

      assert item_image.item_name == "some updated item_name"
      assert item_image.video_url == "some updated video_url"
    end

    # test "update_item_image/2 with invalid data returns error changeset" do
    #  ecommerce_control = build(:ecommerce_control)
    # item_image = insert!(:item_image, ecommerce_control: ecommerce_control)
    # assert {:error, %Ecto.Changeset{}} = Catalogue.update_item_image(item_image, @invalid_attrs)
    # end

    test "delete_item_image/1 deletes the item_image" do
      ecommerce_control = ecommerce_control_fixture()#build(:ecommerce_control)
      item_image = item_image_fixture()#insert!(:item_image, ecommerce_control: ecommerce_control)
      assert {:ok, %ItemImage{}} = Catalogue.delete_item_image(item_image)
    end
  end

  describe "item_tag" do
    alias LetorEcom.Catalogue.ItemTag

    @invalid_attrs %{class: nil, description: nil, name: nil}

    test "create_item_tag/1 with valid data creates a item_tag" do
      name = "#{System.unique_integer()}Vegies"
      valid_attrs = %{class: "some class", description: "some description", name: name}

      assert {:ok, %ItemTag{} = item_tag} = Catalogue.create_item_tag(valid_attrs)
      assert item_tag.class == "some class"
      assert item_tag.description == "some description"
      assert item_tag.name == name
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

    # test "update_item_tag/2 with invalid data returns error changeset" do
    # item_tag = Repo.all(ItemTag) |> List.first()
    # assert {:error, %Ecto.Changeset{}} = Catalogue.update_item_tag(item_tag, @invalid_attrs)
    # end

    # test "delete_item_tag/1 deletes the item_tag" do
    # item_tag = Repo.all(ItemTag) |> List.first()
    # assert {:ok, %ItemTag{}} = Catalogue.delete_item_tag(item_tag)
    # end
  end

  describe "item_taggings" do
    alias LetorEcom.Catalogue.{Item, ItemTag}
    alias LetorEcom.Catalogue.ItemTagging

    @invalid_attrs %{id: nil, item_id: nil, item_tag_id: nil}

    test "create_item_tagging/1 with valid data creates a item_tagging" do
      item = item_fixture()
      item_tag = item_tag_fixture()
      valid_attrs = %{item_id: item.id, item_tag_id: item_tag.id}

      assert {:ok, %ItemTagging{} = item_tagging} = Catalogue.create_item_tagging(valid_attrs)

      assert item_tagging.item_id == item.id
      assert item_tagging.item_tag_id == item_tag.id
    end

    test "create_item_tagging/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_tagging(@invalid_attrs)
    end

    test "update_item_tagging/2 with valid data updates the item_tagging" do
      item_tagging = item_tagging_fixture()
      item = item_fixture()
      item_tag = item_tag_fixture()

      update_attrs = %{item_id: item.id, item_tag_id: item_tag.id}

      assert {:ok, %ItemTagging{} = item_tagging} =
               Catalogue.update_item_tagging(item_tagging, update_attrs)
    end

    test "update_item_tagging/2 with invalid data returns error changeset" do
      item_tagging = item_tagging_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalogue.update_item_tagging(item_tagging, @invalid_attrs)
    end

    test "delete_item_tagging/1 deletes the item_tagging" do
      item_tagging = item_tagging_fixture()
      assert {:ok, %ItemTagging{}} = Catalogue.delete_item_tagging(item_tagging)
    end
  end
end
