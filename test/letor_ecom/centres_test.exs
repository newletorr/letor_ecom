defmodule LetorEcom.CentresTest do
  use LetorEcom.DataCase
  import LetorEcom.Factory

  alias LetorEcom.Centres

  describe "pickup_centres" do
    alias LetorEcom.Centres.PickupCentre
    alias LetorEcom.Control.EcommerceControl

    @invalid_attrs %{
      address: nil,
      area: nil,
      city: nil,
      country: nil,
      location_coordinatess: nil,
      name: nil,
      state: nil
    }

    test "create_pickup_centre/1 with valid data creates a pickup_centre" do
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

      valid_attrs = %{
        address: "some address",
        area: "some area",
        city: "some city",
        country: "some country",
        name: "some name",
        state: "some state",
        location_coordinates: %Geo.Point{
          coordinates: {4.833813967530579, 7.0250130040393675},
          srid: 4326
        },
        ecommerce_control_id: ecommerce_control.id
      }

      assert {:ok, %PickupCentre{} = pickup_centre} = Centres.create_pickup_centre(valid_attrs)
      assert pickup_centre.address == "some address"
      assert pickup_centre.area == "some area"
      assert pickup_centre.city == "some city"
      assert pickup_centre.country == "some country"
      assert pickup_centre.name == "some name"
      assert pickup_centre.state == "some state"
      assert pickup_centre.ecommerce_control_id == ecommerce_control.id
    end

    test "create_pickup_centre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_pickup_centre(@invalid_attrs)
    end

    test "update_pickup_centre/2 with valid data updates the pickup_centre" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()

      update_attrs = %{
        address: "some updated address",
        area: "some updated area",
        city: "some updated city",
        country: "some updated country",
        location_coordinates: %Geo.Point{
          coordinates: {3.90010, 0.90000},
          properties: %{},
          srid: 4326
        },
        name: "some updated name",
        state: "some updated state"
      }

      assert {:ok, %PickupCentre{} = pickup_centre} =
               Centres.update_pickup_centre(pickup_centre, update_attrs)

      assert pickup_centre.address == "some updated address"
      assert pickup_centre.area == "some updated area"
      assert pickup_centre.city == "some updated city"
      assert pickup_centre.country == "some updated country"
      assert pickup_centre.name == "some updated name"
      assert pickup_centre.state == "some updated state"
    end

    test "update_pickup_centre/2 with invalid data returns error changeset" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_pickup_centre(pickup_centre, @invalid_attrs)
    end

    test "delete_pickup_centre/1 deletes the pickup_centre" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      assert {:ok, %PickupCentre{}} = Centres.delete_pickup_centre(pickup_centre)
    end
  end

  describe "inventory_location" do
    alias LetorEcom.Centres.{InventoryLocation, PickupCentre}

    @invalid_attrs %{name: nil, type: nil, pickup_centre_id: nil}

    test "create_inventory_location/1 with valid data creates a inventory_location" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      valid_attrs = %{name: "some name", type: "some type", pickup_centre_id: pickup_centre.id}

      assert {:ok, %InventoryLocation{} = inventory_location} =
               Centres.create_inventory_location(valid_attrs)

      assert inventory_location.name == "some name"
      assert inventory_location.type == "some type"
    end

    test "create_inventory_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_inventory_location(@invalid_attrs)
    end

    test "update_inventory_location/2 with valid data updates the inventory_location" do
      inventory_location = Repo.all(InventoryLocation) |> List.first()
      update_attrs = %{name: "some updated name", type: "some updated type"}

      assert {:ok, %InventoryLocation{} = inventory_location} =
               Centres.update_inventory_location(inventory_location, update_attrs)

      assert inventory_location.name == "some updated name"
      assert inventory_location.type == "some updated type"
    end

    test "update_inventory_location/2 with invalid data returns error changeset" do
      inventory_location = build(:inventory_location)

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_inventory_location(inventory_location, @invalid_attrs)
    end

    test "delete_inventory_location/1 deletes the inventory_location" do
      inventory_location = Repo.all(InventoryLocation) |> List.first()
      assert {:ok, %InventoryLocation{}} = Centres.delete_inventory_location(inventory_location)
    end
  end

  describe "daily_deals" do
    alias LetorEcom.Centres.{DailyDeal, PickupCentre}

    @invalid_attrs %{pickup_centre_id: nil}

    test "create_daily_deal/1 with valid data creates a daily_deal" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      valid_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %DailyDeal{} = daily_deal} = Centres.create_daily_deal(valid_attrs)
    end

    test "create_daily_deal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_daily_deal(@invalid_attrs)
    end

    test "update_daily_deal/2 with valid data updates the daily_deal" do
      daily_deal = Repo.all(DailyDeal) |> List.first()
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      update_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %DailyDeal{} = daily_deal} =
               Centres.update_daily_deal(daily_deal, update_attrs)
    end

    test "update_daily_deal/2 with invalid data returns error changeset" do
      daily_deal = Repo.all(DailyDeal) |> List.first()
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      assert {:error, %Ecto.Changeset{}} = Centres.update_daily_deal(daily_deal, @invalid_attrs)
    end

    test "delete_daily_deal/1 deletes the daily_deal" do
      daily_deal = Repo.all(DailyDeal) |> List.first()
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      assert {:ok, %DailyDeal{}} = Centres.delete_daily_deal(daily_deal)
    end
  end

  describe "popular_items" do
    alias LetorEcom.Centres.{PopularItem, PickupCentre}

    @invalid_attrs %{pickup_centre_id: nil}

    test "create_popular_item/1 with valid data creates a popular_item" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      valid_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %PopularItem{} = popular_item} = Centres.create_popular_item(valid_attrs)
    end

    test "create_popular_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_popular_item(@invalid_attrs)
    end

    test "update_popular_item/2 with valid data updates the popular_item" do
      popular_item = Repo.all(PopularItem) |> List.first()
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      update_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %PopularItem{} = popular_item} =
               Centres.update_popular_item(popular_item, update_attrs)
    end

    test "update_popular_item/2 with invalid data returns error changeset" do
      popular_item = Repo.all(PopularItem) |> List.first()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_popular_item(popular_item, @invalid_attrs)
    end

    # test "delete_popular_item/1 deletes the popular_item" do
    #  popular_item = Repo.all(PopularItem) |> List.first()
    # assert {:ok, %PopularItem{}} = Centres.delete_popular_item(popular_item)
    # end
  end

  describe "featured_items" do
    alias LetorEcom.Centres.{FeaturedItem, PickupCentre}

    @invalid_attrs %{pickup_centre_id: nil}

    test "create_featured_item/1 with valid data creates a featured_item" do
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      valid_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %FeaturedItem{} = featured_item} = Centres.create_featured_item(valid_attrs)
    end

    test "create_featured_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_featured_item(@invalid_attrs)
    end

    test "update_featured_item/2 with valid data updates the featured_item" do
      featured_item = Repo.all(FeaturedItem) |> List.first()
      pickup_centre = Repo.all(PickupCentre) |> List.first()
      update_attrs = %{pickup_centre_id: pickup_centre.id}

      assert {:ok, %FeaturedItem{} = featured_item} =
               Centres.update_featured_item(featured_item, update_attrs)
    end

    test "update_featured_item/2 with invalid data returns error changeset" do
      featured_item = Repo.all(FeaturedItem) |> List.first()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_featured_item(featured_item, @invalid_attrs)
    end

    # test "delete_featured_item/1 deletes the featured_item" do
    #  featured_item = Repo.all(FeaturedItem) |> List.first()
    # assert {:ok, %FeaturedItem{}} = Centres.delete_featured_item(featured_item)
    # end
  end

  describe "inventories" do
    alias LetorEcom.Centres.Inventory

    @invalid_attrs %{
      brand_name: nil,
      buy_price: nil,
      description: nil,
      expired: nil,
      expiry_date: nil,
      external_quantity: nil,
      external_quantity_uom: nil,
      internal_quantity_uom: nil,
      internal_quantity: nil,
      max_external_quantity: nil,
      max_internal_quantity: nil,
      name: nil,
      qr_code: nil,
      quality_assurance_status: nil,
      sales_price: nil,
      size: nil,
      status: nil
    }

    test "create_inventory/1 with valid data creates a inventory" do
      valid_attrs = %{
        brand_name: "some brand_name",
        buy_price: "120.5",
        description: "some description",
        expired: true,
        expiry_date: ~D[2022-04-06],
        external_quantity: 42,
        external_quantity_uom: "some external_quantity_uom",
        internal_quantity_uom: "some internal_quantity_uom",
        internal_quantity: 42,
        max_external_quantity: 42,
        max_internal_quantity: 42,
        name: "some name",
        qr_code: "some qr_code",
        quality_assurance_status: "some quality_assurance_status",
        sales_price: "120.5",
        size: 42,
        status: "some status"
      }

      assert {:ok, %Inventory{} = inventory} = Centres.create_inventory(valid_attrs)
      assert inventory.brand_name == "some brand_name"
      assert inventory.buy_price == Decimal.new("120.5")
      assert inventory.description == "some description"
      assert inventory.expired == true
      assert inventory.expiry_date == ~D[2022-04-06]
      assert inventory.external_quantity == 42
      assert inventory.external_quantity_uom == "some external_quantity_uom"
      assert inventory.internal_quantity_uom == "some internal_quantity_uom"
      assert inventory.internal_quantity == 42
      assert inventory.max_external_quantity == 42
      assert inventory.max_internal_quantity == 42
      assert inventory.name == "some name"
      assert inventory.qr_code == "some qr_code"
      assert inventory.quality_assurance_status == "some quality_assurance_status"
      assert inventory.sales_price == Decimal.new("120.5")
      assert inventory.size == 42
      assert inventory.status == "some status"
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = Repo.all(Inventory) |> List.first()

      update_attrs = %{
        brand_name: "some updated brand_name",
        buy_price: "456.7",
        description: "some updated description",
        expired: false,
        expiry_date: ~D[2022-04-07],
        external_quantity: 43,
        external_quantity_uom: "some updated external_quantity_uom",
        internal_quantity_uom: "some updated internal_quantity_uom",
        internal_quantity: 43,
        max_external_quantity: 43,
        max_internal_quantity: 43,
        name: "some updated name",
        qr_code: "some updated qr_code",
        quality_assurance_status: "some updated quality_assurance_status",
        sales_price: "456.7",
        size: 43,
        status: "some updated status"
      }

      assert {:ok, %Inventory{} = inventory} = Centres.update_inventory(inventory, update_attrs)
      assert inventory.brand_name == "some updated brand_name"
      assert inventory.buy_price == Decimal.new("456.7")
      assert inventory.description == "some updated description"
      assert inventory.expired == false
      assert inventory.expiry_date == ~D[2022-04-07]
      assert inventory.external_quantity == 43
      assert inventory.external_quantity_uom == "some updated external_quantity_uom"
      assert inventory.internal_quantity_uom == "some updated internal_quantity_uom"
      assert inventory.internal_quantity == 43
      assert inventory.max_external_quantity == 43
      assert inventory.max_internal_quantity == 43
      assert inventory.name == "some updated name"
      assert inventory.qr_code == "some updated qr_code"
      assert inventory.quality_assurance_status == "some updated quality_assurance_status"
      assert inventory.sales_price == Decimal.new("456.7")
      assert inventory.size == 43
      assert inventory.status == "some updated status"
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = Repo.all(Inventory) |> List.first()
      assert {:error, %Ecto.Changeset{}} = Centres.update_inventory(inventory, @invalid_attrs)
    end

    #test "delete_inventory/1 deletes the inventory" do
     # inventory = Repo.all(Inventory) |> List.first()
      #assert {:ok, %Inventory{}} = Centres.delete_inventory(inventory)
    #end
  end

  describe "inventory_change_history" do
    alias LetorEcom.Centres.{Inventory, InventoryChangeHistory}

    @invalid_attrs %{
      buy_price: nil,
      external_quantity: nil,
      internal_quantity: nil,
      sales_price: nil,
      inventory_id: nil,
      change_type: nil
    }

    test "create_inventory_change_history/1 with valid data creates a inventory_change_history" do
      inventory = Repo.all(Inventory) |> List.first()

      valid_attrs = %{
        buy_price: Decimal.new("120.5"),
        external_quantity: 42,
        internal_quantity: 42,
        sales_price: Decimal.new("120.5"),
        change_type: "created",
        inventory_id: inventory.id
      }

      assert {:ok, %InventoryChangeHistory{} = inventory_change_history} =
               Centres.create_inventory_change_history(valid_attrs)

      assert inventory_change_history.buy_price == Decimal.new("120.5")
      assert inventory_change_history.external_quantity == 42
      assert inventory_change_history.internal_quantity == 42
      assert inventory_change_history.change_type == "created"
      assert inventory_change_history.sales_price == Decimal.new("120.5")
    end

    test "create_inventory_change_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_inventory_change_history(@invalid_attrs)
    end

    test "update_inventory_change_history/2 with valid data updates the inventory_change_history" do
      inventory_change_history = Repo.all(InventoryChangeHistory) |> List.first()
      inventory = Repo.all(Inventory) |> List.first()

      update_attrs = %{
        buy_price: "456.7",
        external_quantity: 43,
        internal_quantity: 43,
        sales_price: "456.7",
        change_type: "updated",
        inventory_id: inventory.id
      }

      assert {:ok, %InventoryChangeHistory{} = inventory_change_history} =
               Centres.update_inventory_change_history(inventory_change_history, update_attrs)

      assert inventory_change_history.buy_price == Decimal.new("456.7")
      assert inventory_change_history.external_quantity == 43
      assert inventory_change_history.internal_quantity == 43
      assert inventory_change_history.change_type == "updated"
      assert inventory_change_history.sales_price == Decimal.new("456.7")
    end

    test "update_inventory_change_history/2 with invalid data returns error changeset" do
      inventory_change_history =
        inventory_change_history = Repo.all(InventoryChangeHistory) |> List.first()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_inventory_change_history(inventory_change_history, @invalid_attrs)
    end

    test "delete_inventory_change_history/1 deletes the inventory_change_history" do
      inventory_change_history = Repo.all(InventoryChangeHistory) |> List.first()

      assert {:ok, %InventoryChangeHistory{}} =
               Centres.delete_inventory_change_history(inventory_change_history)
    end
  end
end
