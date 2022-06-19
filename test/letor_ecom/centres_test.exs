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
      bulk_quantity: nil,
      bulk_quantity_uom: nil,
      sales_unit_quantity_uom: nil,
      sales_unit_quantity: nil,
      max_bulk_quantity: nil,
      max_sales_unit_quantity: nil,
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
        bulk_quantity: 42,
        bulk_quantity_uom: "some bulk_quantity_uom",
        sales_unit_quantity_uom: "some sales_unit_quantity_uom",
        sales_unit_quantity: 42,
        max_bulk_quantity: 42,
        max_sales_unit_quantity: 42,
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
      assert inventory.bulk_quantity == 42
      assert inventory.bulk_quantity_uom == "some bulk_quantity_uom"
      assert inventory.sales_unit_quantity_uom == "some sales_unit_quantity_uom"
      assert inventory.sales_unit_quantity == 42
      assert inventory.max_bulk_quantity == 42
      assert inventory.max_sales_unit_quantity == 42
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
        bulk_quantity: 43,
        bulk_quantity_uom: "some updated bulk_quantity_uom",
        sales_unit_quantity_uom: "some updated sales_unit_quantity_uom",
        sales_unit_quantity: 43,
        max_bulk_quantity: 43,
        max_sales_unit_quantity: 43,
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
      assert inventory.bulk_quantity == 43
      assert inventory.bulk_quantity_uom == "some updated bulk_quantity_uom"
      assert inventory.sales_unit_quantity_uom == "some updated sales_unit_quantity_uom"
      assert inventory.sales_unit_quantity == 43
      assert inventory.max_bulk_quantity == 43
      assert inventory.max_sales_unit_quantity == 43
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

    # test "delete_inventory/1 deletes the inventory" do
    # inventory = Repo.all(Inventory) |> List.first()
    # assert {:ok, %Inventory{}} = Centres.delete_inventory(inventory)
    # end
  end

  describe "inventory_change_history" do
    alias LetorEcom.Centres.{Inventory, InventoryChangeHistory}

    @invalid_attrs %{
      buy_price: nil,
      bulk_quantity: nil,
      sales_unit_quantity: nil,
      sales_price: nil,
      inventory_id: nil,
      change_type: nil
    }

    test "create_inventory_change_history/1 with valid data creates a inventory_change_history" do
      inventory = Repo.all(Inventory) |> List.first()

      valid_attrs = %{
        buy_price: Decimal.new("120.5"),
        bulk_quantity: 42,
        sales_unit_quantity: 42,
        sales_price: Decimal.new("120.5"),
        change_type: "created",
        inventory_id: inventory.id
      }

      assert {:ok, %InventoryChangeHistory{} = inventory_change_history} =
               Centres.create_inventory_change_history(valid_attrs)

      assert inventory_change_history.buy_price == Decimal.new("120.5")
      assert inventory_change_history.bulk_quantity == 42
      assert inventory_change_history.sales_unit_quantity == 42
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
        bulk_quantity: 43,
        sales_unit_quantity: 43,
        sales_price: "456.7",
        change_type: "updated",
        inventory_id: inventory.id
      }

      assert {:ok, %InventoryChangeHistory{} = inventory_change_history} =
               Centres.update_inventory_change_history(inventory_change_history, update_attrs)

      assert inventory_change_history.buy_price == Decimal.new("456.7")
      assert inventory_change_history.bulk_quantity == 43
      assert inventory_change_history.sales_unit_quantity == 43
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

  describe "pick_ups" do
    alias LetorEcom.Centres.PickUp

    import LetorEcom.CentresFixtures

    @invalid_attrs %{pick_up_code: nil, pick_up_time: nil, picked: nil}

    test "list_pick_ups/0 returns all pick_ups" do
      pick_up = pick_up_fixture()
      assert Centres.list_pick_ups() == [pick_up]
    end

    test "get_pick_up!/1 returns the pick_up with given id" do
      pick_up = pick_up_fixture()
      assert Centres.get_pick_up!(pick_up.id) == pick_up
    end

    test "create_pick_up/1 with valid data creates a pick_up" do
      valid_attrs = %{
        pick_up_code: "some pick_up_code",
        pick_up_time: ~U[2022-05-07 23:03:00Z],
        picked: true
      }

      assert {:ok, %PickUp{} = pick_up} = Centres.create_pick_up(valid_attrs)
      assert pick_up.pick_up_code == "some pick_up_code"
      assert pick_up.pick_up_time == ~U[2022-05-07 23:03:00Z]
      assert pick_up.picked == true
    end

    test "create_pick_up/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_pick_up(@invalid_attrs)
    end

    test "update_pick_up/2 with valid data updates the pick_up" do
      pick_up = pick_up_fixture()

      update_attrs = %{
        pick_up_code: "some updated pick_up_code",
        pick_up_time: ~U[2022-05-08 23:03:00Z],
        picked: false
      }

      assert {:ok, %PickUp{} = pick_up} = Centres.update_pick_up(pick_up, update_attrs)
      assert pick_up.pick_up_code == "some updated pick_up_code"
      assert pick_up.pick_up_time == ~U[2022-05-08 23:03:00Z]
      assert pick_up.picked == false
    end

    test "update_pick_up/2 with invalid data returns error changeset" do
      pick_up = pick_up_fixture()
      assert {:error, %Ecto.Changeset{}} = Centres.update_pick_up(pick_up, @invalid_attrs)
      assert pick_up == Centres.get_pick_up!(pick_up.id)
    end

    test "delete_pick_up/1 deletes the pick_up" do
      pick_up = pick_up_fixture()
      assert {:ok, %PickUp{}} = Centres.delete_pick_up(pick_up)
      assert_raise Ecto.NoResultsError, fn -> Centres.get_pick_up!(pick_up.id) end
    end

    test "change_pick_up/1 returns a pick_up changeset" do
      pick_up = pick_up_fixture()
      assert %Ecto.Changeset{} = Centres.change_pick_up(pick_up)
    end
  end

  describe "quality_assurance_requirements" do
    alias LetorEcom.Centres.QualityAssuranceRequirement

    import LetorEcom.CentresFixtures

    @invalid_attrs %{
      acceptable_quantity_of_damage_item: nil,
      broken_seal: nil,
      damaged_containers: nil,
      describe_firmness: nil,
      describe_observed_fungal_growth: nil,
      expired: nil,
      expiry_date: nil,
      firmness: nil,
      good_color: nil,
      no_of_rusty_cans: nil,
      number_of_damaged_containers: nil,
      number_of_items_with_broken_seal: nil,
      observed_fungal_growth: nil,
      product_type: nil,
      rusty_cans: nil
    }

    test "list_quality_assurance_requirements/0 returns all quality_assurance_requirements" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()
      assert Centres.list_quality_assurance_requirements() == [quality_assurance_requirement]
    end

    test "get_quality_assurance_requirement!/1 returns the quality_assurance_requirement with given id" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()

      assert Centres.get_quality_assurance_requirement!(quality_assurance_requirement.id) ==
               quality_assurance_requirement
    end

    test "create_quality_assurance_requirement/1 with valid data creates a quality_assurance_requirement" do
      valid_attrs = %{
        acceptable_quantity_of_damage_item: true,
        broken_seal: true,
        damaged_containers: true,
        describe_firmness: "some describe_firmness",
        describe_observed_fungal_growth: "some describe_observed_fungal_growth",
        expired: true,
        expiry_date: ~D[2022-05-15],
        firmness: true,
        good_color: "some good_color",
        no_of_rusty_cans: 42,
        number_of_damaged_containers: 42,
        number_of_items_with_broken_seal: 42,
        observed_fungal_growth: true,
        product_type: "some product_type",
        rusty_cans: true
      }

      assert {:ok, %QualityAssuranceRequirement{} = quality_assurance_requirement} =
               Centres.create_quality_assurance_requirement(valid_attrs)

      assert quality_assurance_requirement.acceptable_quantity_of_damage_item == true
      assert quality_assurance_requirement.broken_seal == true
      assert quality_assurance_requirement.damaged_containers == true
      assert quality_assurance_requirement.describe_firmness == "some describe_firmness"

      assert quality_assurance_requirement.describe_observed_fungal_growth ==
               "some describe_observed_fungal_growth"

      assert quality_assurance_requirement.expired == true
      assert quality_assurance_requirement.expiry_date == ~D[2022-05-15]
      assert quality_assurance_requirement.firmness == true
      assert quality_assurance_requirement.good_color == "some good_color"
      assert quality_assurance_requirement.no_of_rusty_cans == 42
      assert quality_assurance_requirement.number_of_damaged_containers == 42
      assert quality_assurance_requirement.number_of_items_with_broken_seal == 42
      assert quality_assurance_requirement.observed_fungal_growth == true
      assert quality_assurance_requirement.product_type == "some product_type"
      assert quality_assurance_requirement.rusty_cans == true
    end

    test "create_quality_assurance_requirement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Centres.create_quality_assurance_requirement(@invalid_attrs)
    end

    test "update_quality_assurance_requirement/2 with valid data updates the quality_assurance_requirement" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()

      update_attrs = %{
        acceptable_quantity_of_damage_item: false,
        broken_seal: false,
        damaged_containers: false,
        describe_firmness: "some updated describe_firmness",
        describe_observed_fungal_growth: "some updated describe_observed_fungal_growth",
        expired: false,
        expiry_date: ~D[2022-05-16],
        firmness: false,
        good_color: "some updated good_color",
        no_of_rusty_cans: 43,
        number_of_damaged_containers: 43,
        number_of_items_with_broken_seal: 43,
        observed_fungal_growth: false,
        product_type: "some updated product_type",
        rusty_cans: false
      }

      assert {:ok, %QualityAssuranceRequirement{} = quality_assurance_requirement} =
               Centres.update_quality_assurance_requirement(
                 quality_assurance_requirement,
                 update_attrs
               )

      assert quality_assurance_requirement.acceptable_quantity_of_damage_item == false
      assert quality_assurance_requirement.broken_seal == false
      assert quality_assurance_requirement.damaged_containers == false
      assert quality_assurance_requirement.describe_firmness == "some updated describe_firmness"

      assert quality_assurance_requirement.describe_observed_fungal_growth ==
               "some updated describe_observed_fungal_growth"

      assert quality_assurance_requirement.expired == false
      assert quality_assurance_requirement.expiry_date == ~D[2022-05-16]
      assert quality_assurance_requirement.firmness == false
      assert quality_assurance_requirement.good_color == "some updated good_color"
      assert quality_assurance_requirement.no_of_rusty_cans == 43
      assert quality_assurance_requirement.number_of_damaged_containers == 43
      assert quality_assurance_requirement.number_of_items_with_broken_seal == 43
      assert quality_assurance_requirement.observed_fungal_growth == false
      assert quality_assurance_requirement.product_type == "some updated product_type"
      assert quality_assurance_requirement.rusty_cans == false
    end

    test "update_quality_assurance_requirement/2 with invalid data returns error changeset" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_quality_assurance_requirement(
                 quality_assurance_requirement,
                 @invalid_attrs
               )

      assert quality_assurance_requirement ==
               Centres.get_quality_assurance_requirement!(quality_assurance_requirement.id)
    end

    test "delete_quality_assurance_requirement/1 deletes the quality_assurance_requirement" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()

      assert {:ok, %QualityAssuranceRequirement{}} =
               Centres.delete_quality_assurance_requirement(quality_assurance_requirement)

      assert_raise Ecto.NoResultsError, fn ->
        Centres.get_quality_assurance_requirement!(quality_assurance_requirement.id)
      end
    end

    test "change_quality_assurance_requirement/1 returns a quality_assurance_requirement changeset" do
      quality_assurance_requirement = quality_assurance_requirement_fixture()

      assert %Ecto.Changeset{} =
               Centres.change_quality_assurance_requirement(quality_assurance_requirement)
    end
  end

  describe "purchases" do
    alias LetorEcom.Centres.Purchase

    import LetorEcom.CentresFixtures

    @invalid_attrs %{
      approval_remark: nil,
      code: nil,
      creators_remark: nil,
      delivered: nil,
      finished: nil,
      quality_assurance_cleared: nil,
      status: nil
    }

    test "list_purchases/0 returns all purchases" do
      purchase = purchase_fixture()
      assert Centres.list_purchases() == [purchase]
    end

    test "get_purchase!/1 returns the purchase with given id" do
      purchase = purchase_fixture()
      assert Centres.get_purchase!(purchase.id) == purchase
    end

    test "create_purchase/1 with valid data creates a purchase" do
      valid_attrs = %{
        approval_remark: "some approval_remark",
        code: "some code",
        creators_remark: "some creators_remark",
        delivered: true,
        finished: true,
        quality_assurance_cleared: true,
        status: "some status"
      }

      assert {:ok, %Purchase{} = purchase} = Centres.create_purchase(valid_attrs)
      assert purchase.approval_remark == "some approval_remark"
      assert purchase.code == "some code"
      assert purchase.creators_remark == "some creators_remark"
      assert purchase.delivered == true
      assert purchase.finished == true
      assert purchase.quality_assurance_cleared == true
      assert purchase.status == "some status"
    end

    test "create_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_purchase(@invalid_attrs)
    end

    test "update_purchase/2 with valid data updates the purchase" do
      purchase = purchase_fixture()

      update_attrs = %{
        approval_remark: "some updated approval_remark",
        code: "some updated code",
        creators_remark: "some updated creators_remark",
        delivered: false,
        finished: false,
        quality_assurance_cleared: false,
        status: "some updated status"
      }

      assert {:ok, %Purchase{} = purchase} = Centres.update_purchase(purchase, update_attrs)
      assert purchase.approval_remark == "some updated approval_remark"
      assert purchase.code == "some updated code"
      assert purchase.creators_remark == "some updated creators_remark"
      assert purchase.delivered == false
      assert purchase.finished == false
      assert purchase.quality_assurance_cleared == false
      assert purchase.status == "some updated status"
    end

    test "update_purchase/2 with invalid data returns error changeset" do
      purchase = purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = Centres.update_purchase(purchase, @invalid_attrs)
      assert purchase == Centres.get_purchase!(purchase.id)
    end

    test "delete_purchase/1 deletes the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{}} = Centres.delete_purchase(purchase)
      assert_raise Ecto.NoResultsError, fn -> Centres.get_purchase!(purchase.id) end
    end

    test "change_purchase/1 returns a purchase changeset" do
      purchase = purchase_fixture()
      assert %Ecto.Changeset{} = Centres.change_purchase(purchase)
    end
  end

  describe "purchase_items" do
    alias LetorEcom.Centres.PurchaseItem

    import LetorEcom.CentresFixtures

    @invalid_attrs %{
      item_name: nil,
      quantity: nil,
      suppliers_email: nil,
      suppliers_name: nil,
      suppliers_phone: nil,
      total: nil,
      unit_price: nil
    }

    test "list_purchase_items/0 returns all purchase_items" do
      purchase_item = purchase_item_fixture()
      assert Centres.list_purchase_items() == [purchase_item]
    end

    test "get_purchase_item!/1 returns the purchase_item with given id" do
      purchase_item = purchase_item_fixture()
      assert Centres.get_purchase_item!(purchase_item.id) == purchase_item
    end

    test "create_purchase_item/1 with valid data creates a purchase_item" do
      valid_attrs = %{
        item_name: "some item_name",
        quantity: 42,
        suppliers_email: "some suppliers_email",
        suppliers_name: "some suppliers_name",
        suppliers_phone: "some suppliers_phone",
        total: "120.5",
        unit_price: "some unit_price"
      }

      assert {:ok, %PurchaseItem{} = purchase_item} = Centres.create_purchase_item(valid_attrs)
      assert purchase_item.item_name == "some item_name"
      assert purchase_item.quantity == 42
      assert purchase_item.suppliers_email == "some suppliers_email"
      assert purchase_item.suppliers_name == "some suppliers_name"
      assert purchase_item.suppliers_phone == "some suppliers_phone"
      assert purchase_item.total == Decimal.new("120.5")
      assert purchase_item.unit_price == "some unit_price"
    end

    test "create_purchase_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_purchase_item(@invalid_attrs)
    end

    test "update_purchase_item/2 with valid data updates the purchase_item" do
      purchase_item = purchase_item_fixture()

      update_attrs = %{
        item_name: "some updated item_name",
        quantity: 43,
        suppliers_email: "some updated suppliers_email",
        suppliers_name: "some updated suppliers_name",
        suppliers_phone: "some updated suppliers_phone",
        total: "456.7",
        unit_price: "some updated unit_price"
      }

      assert {:ok, %PurchaseItem{} = purchase_item} =
               Centres.update_purchase_item(purchase_item, update_attrs)

      assert purchase_item.item_name == "some updated item_name"
      assert purchase_item.quantity == 43
      assert purchase_item.suppliers_email == "some updated suppliers_email"
      assert purchase_item.suppliers_name == "some updated suppliers_name"
      assert purchase_item.suppliers_phone == "some updated suppliers_phone"
      assert purchase_item.total == Decimal.new("456.7")
      assert purchase_item.unit_price == "some updated unit_price"
    end

    test "update_purchase_item/2 with invalid data returns error changeset" do
      purchase_item = purchase_item_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_purchase_item(purchase_item, @invalid_attrs)

      assert purchase_item == Centres.get_purchase_item!(purchase_item.id)
    end

    test "delete_purchase_item/1 deletes the purchase_item" do
      purchase_item = purchase_item_fixture()
      assert {:ok, %PurchaseItem{}} = Centres.delete_purchase_item(purchase_item)
      assert_raise Ecto.NoResultsError, fn -> Centres.get_purchase_item!(purchase_item.id) end
    end

    test "change_purchase_item/1 returns a purchase_item changeset" do
      purchase_item = purchase_item_fixture()
      assert %Ecto.Changeset{} = Centres.change_purchase_item(purchase_item)
    end
  end

  describe "batches" do
    alias LetorEcom.Centres.Batch

    import LetorEcom.CentresFixtures

    @invalid_attrs %{code: nil, description: nil}

    test "list_batches/0 returns all batches" do
      batch = batch_fixture()
      assert Centres.list_batches() == [batch]
    end

    test "get_batch!/1 returns the batch with given id" do
      batch = batch_fixture()
      assert Centres.get_batch!(batch.id) == batch
    end

    test "create_batch/1 with valid data creates a batch" do
      valid_attrs = %{code: "some code", description: "some description"}

      assert {:ok, %Batch{} = batch} = Centres.create_batch(valid_attrs)
      assert batch.code == "some code"
      assert batch.description == "some description"
    end

    test "create_batch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_batch(@invalid_attrs)
    end

    test "update_batch/2 with valid data updates the batch" do
      batch = batch_fixture()
      update_attrs = %{code: "some updated code", description: "some updated description"}

      assert {:ok, %Batch{} = batch} = Centres.update_batch(batch, update_attrs)
      assert batch.code == "some updated code"
      assert batch.description == "some updated description"
    end

    test "update_batch/2 with invalid data returns error changeset" do
      batch = batch_fixture()
      assert {:error, %Ecto.Changeset{}} = Centres.update_batch(batch, @invalid_attrs)
      assert batch == Centres.get_batch!(batch.id)
    end

    test "delete_batch/1 deletes the batch" do
      batch = batch_fixture()
      assert {:ok, %Batch{}} = Centres.delete_batch(batch)
      assert_raise Ecto.NoResultsError, fn -> Centres.get_batch!(batch.id) end
    end

    test "change_batch/1 returns a batch changeset" do
      batch = batch_fixture()
      assert %Ecto.Changeset{} = Centres.change_batch(batch)
    end
  end
end
