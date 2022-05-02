defmodule LetorEcom.CatalogueTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory
  alias LetorEcom.Catalogue
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.Control.EcommerceControl
  alias LetorEcom.Repo

  describe "item_categories" do
    alias LetorEcom.Catalogue.ItemCategory

    @invalid_attrs %{description: nil, name: nil}

    test "create_item_category/1 with valid data creates a item_category" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()

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
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      item_category = insert!(:item_category, pickup_centre: pickup_centre)
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
      item_category = Repo.all(ItemCategory) |> List.first()

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
      item_category = build(:item_category)
      item_subcategory = insert!(:item_subcategory, item_category: item_category)
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

    alias LetorEcom.Catalogue.{Item, ItemImage, ItemSubcategory}
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
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      item_subcategory = Repo.all(ItemSubcategory) |> List.first()
      item_image = Repo.all(ItemImage) |> List.first()
      inventory_location = Repo.all(InventoryLocation) |> List.first()

      valid_attrs = %{
        barcode: "some barcode",
        details: "some details",
        brand_name: "some brand_name",
        item_subcategory_id: item_subcategory.id,
        type: "some type",
        main_price: Decimal.new("120.5"),
        package_size: "some package size",
        item_image_id: item_image.id,
        pickup_centre_id: pickup_centre.id,
        inventory_location_id: inventory_location.id,
        description: "some description",
        max_internal_quantity: 60,
        max_external_quantity: 60,
        name: "some name",
        details: "some details",
        internal_quantity: 40,
        external_quantity: 50,
        internal_quantity_uom: "some uom",
        external_quantity_uom: "some uom",
        buy_price: Decimal.new("120.5"),
        sales_price: Decimal.new("300.9"),
        status: "available",
        expiry_date: ~D[2023-02-03]
      }

      assert {:ok, %{sku: sku}} = Catalogue.create_sku_inventory_and_item(valid_attrs)
      assert sku.name == "some name"
    end

    # test "create_sku/1 with invalid data returns error changeset" do
    #  assert {:error, :sku, _changeset, _} =
    #          Catalogue.create_sku_inventory_and_item(@invalid_attrs)
    # end

    test "update_sku/2 with valid data updates the sku" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)

      sku = insert!(:sku, pickup_centre: pickup_centre)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Sku{} = sku} = Catalogue.update_sku(sku, update_attrs)
      assert sku.name == "some updated name"
    end

    # test "update_sku/2 with invalid data returns error changeset" do
    # sku = Repo.all(Sku) |> List.first()
    # assert {:error, %Ecto.Changeset{}} = Catalogue.update_sku(sku, @invalid_attrs)
    # end

    test "delete_sku/1 deletes the sku" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      sku = insert!(:sku, pickup_centre: pickup_centre)
      assert {:ok, %Sku{}} = Catalogue.delete_sku(sku)
    end
  end

  describe "items" do
    alias LetorEcom.Catalogue.{Item, ItemImage, ItemSubcategory}
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
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      item_subcategory = Repo.all(ItemSubcategory) |> List.first()
      item_image = Repo.all(ItemImage) |> List.first()
      inventory_location = Repo.all(InventoryLocation) |> List.first()

      valid_attrs = %{
        barcode: "some barcode",
        details: "some details",
        brand_name: "some brand_name",
        item_subcategory_id: item_subcategory.id,
        type: "some type",
        main_price: Decimal.new("120.5"),
        package_size: "some package size",
        item_image_id: item_image.id,
        pickup_centre_id: pickup_centre.id,
        inventory_location_id: inventory_location.id,
        description: "some description",
        max_internal_quantity: 60,
        max_external_quantity: 60,
        name: "some name",
        details: "some details",
        internal_quantity: 40,
        external_quantity: 50,
        internal_quantity_uom: "some uom",
        external_quantity_uom: "some uom",
        buy_price: Decimal.new("120.5"),
        sales_price: Decimal.new("300.9"),
        status: "available",
        expiry_date: ~D[2023-02-03]
      }

      assert {:ok, %{item: item}} = Catalogue.create_sku_inventory_and_item(valid_attrs)
      assert item.actual_price == Decimal.new("120.5")
      assert item.barcode == "some barcode"
      assert item.brand_name == "some brand_name"
      assert item.bulk == false
      assert item.customization_allowed == false
      assert item.description == "some description"
      assert item.details == "some details"
      assert item.expired == false
      assert item.main_price == Decimal.new("120.5")
      assert item.name == "some name"
      assert item.out_of_stock == false
      assert item.package_size == "some package size"
      assert item.qa_cleared == false
      assert item.type == "some type"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, :item, _changeset, _} =
               Catalogue.create_sku_inventory_and_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item_subcategory = build(:item_subcategory)
      item = insert!(:item, item_subcategory: item_subcategory)

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
        package_size: "some updated package_size",
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
      assert item.package_size == "some updated package_size"
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
      item_subcategory = build(:item_subcategory)
      item = insert!(:item, item_subcategory: item_subcategory)
      assert {:ok, %Item{}} = Catalogue.delete_item(item)
    end
  end

  describe "item_images" do
    alias LetorEcom.Catalogue.ItemImage

    @invalid_attrs %{
      item_name: nil,
      video_url: nil,
      ecommerce_control_id: nil
    }

    test "create_item_image/1 with valid data creates a item_image" do
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

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
    end

    test "create_item_image/1 with invalid data returns error changeset" do
      assert {:error, :item_image, _changeset, _} = Catalogue.create_item_image(@invalid_attrs)
    end

    test "update_item_image/2 with valid data updates the item_image" do
      ecommerce_control = build(:ecommerce_control)
      item_image = insert!(:item_image, ecommerce_control: ecommerce_control)

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
      ecommerce_control = build(:ecommerce_control)
      item_image = insert!(:item_image, ecommerce_control: ecommerce_control)
      assert {:ok, %ItemImage{}} = Catalogue.delete_item_image(item_image)
    end
  end

  describe "item_tag" do
    alias LetorEcom.Catalogue.ItemTag

    @invalid_attrs %{class: nil, description: nil, name: nil}

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
      item_tag = Repo.all(ItemTag) |> List.first()

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

    @invalid_attrs %{item_id: nil, item_tag_id: nil}

    test "create_item_tagging/1 with valid data creates a item_tagging" do
      item = Repo.all(Item) |> List.first()
      item_tag = Repo.all(ItemTag) |> List.first()
      valid_attrs = %{item_id: item.id, item_tag_id: item_tag.id}

      assert {:ok, %ItemTagging{} = item_tagging} = Catalogue.create_item_tagging(valid_attrs)

      assert item_tagging.item_id == item.id
      assert item_tagging.item_tag_id == item_tag.id
    end

    test "create_item_tagging/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_item_tagging(@invalid_attrs)
    end

    test "update_item_tagging/2 with valid data updates the item_tagging" do
      item_tagging = Repo.all(ItemTagging) |> List.first()
      item = Repo.all(Item) |> List.first()
      item_tag = Repo.all(ItemTag) |> List.first()

      update_attrs = %{item_id: item.id, item_tag_id: item_tag.id}

      assert {:ok, %ItemTagging{} = item_tagging} =
               Catalogue.update_item_tagging(item_tagging, update_attrs)
    end

    test "update_item_tagging/2 with invalid data returns error changeset" do
      item = build(:item)
      item_tag = build(:item_tag)
      item_tagging = insert!(:item_tagging, item: item, item_tag: item_tag)

      assert {:error, %Ecto.Changeset{}} =
               Catalogue.update_item_tagging(item_tagging, @invalid_attrs)
    end

    test "delete_item_tagging/1 deletes the item_tagging" do
      item_tagging = Repo.all(ItemTagging) |> List.first()
      assert {:ok, %ItemTagging{}} = Catalogue.delete_item_tagging(item_tagging)
    end
  end
end
