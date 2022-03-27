defmodule LetorEcom.CentresTest do
  use LetorEcom.DataCase

  alias LetorEcom.Centres

  describe "pickup_centres" do
    alias LetorEcom.Centres.PickupCentre

    import LetorEcom.CentresFixtures
    import LetorEcom.ControlFixtures

    @invalid_attrs %{
      address: nil,
      area: nil,
      city: nil,
      country: nil,
      location_coordinates: nil,
      name: nil,
      state: nil
    }

    test "list_pickup_centres/0 returns all pickup_centres" do
      pickup_centre = pickup_centre_fixture()
      assert Centres.list_pickup_centres() == [pickup_centre]
    end

    test "get_pickup_centre!/1 returns the pickup_centre with given id" do
      pickup_centre = pickup_centre_fixture()
      assert Centres.get_pickup_centre!(pickup_centre.id) == pickup_centre
    end

    test "create_pickup_centre/1 with valid data creates a pickup_centre" do
      centre_code = centre_code_fixture()
      ecommerce_control = ecommerce_control_fixture()

      valid_attrs = %{
        address: "some address",
        area: "some area",
        city: "some city",
        country: "some country",
        location_coordinates: "some location_coordinates",
        name: "some name",
        state: "some state",
        centre_code_id: centre_code.id,
        ecommerce_control_id: ecommerce_control.id
      }

      assert {:ok, %PickupCentre{} = pickup_centre} = Centres.create_pickup_centre(valid_attrs)
      assert pickup_centre.address == "some address"
      assert pickup_centre.area == "some area"
      assert pickup_centre.city == "some city"
      assert pickup_centre.country == "some country"
      assert pickup_centre.location_coordinates == "some location_coordinates"
      assert pickup_centre.name == "some name"
      assert pickup_centre.state == "some state"
      assert pickup_centre.centre_code_id == centre_code.id
      assert pickup_centre.ecommerce_control_id == ecommerce_control.id
    end

    test "create_pickup_centre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Centres.create_pickup_centre(@invalid_attrs)
    end

    test "update_pickup_centre/2 with valid data updates the pickup_centre" do
      pickup_centre = pickup_centre_fixture()

      update_attrs = %{
        address: "some updated address",
        area: "some updated area",
        city: "some updated city",
        country: "some updated country",
        location_coordinates: "some updated location_coordinates",
        name: "some updated name",
        state: "some updated state"
      }

      assert {:ok, %PickupCentre{} = pickup_centre} =
               Centres.update_pickup_centre(pickup_centre, update_attrs)

      assert pickup_centre.address == "some updated address"
      assert pickup_centre.area == "some updated area"
      assert pickup_centre.city == "some updated city"
      assert pickup_centre.country == "some updated country"
      assert pickup_centre.location_coordinates == "some updated location_coordinates"
      assert pickup_centre.name == "some updated name"
      assert pickup_centre.state == "some updated state"
    end

    test "update_pickup_centre/2 with invalid data returns error changeset" do
      pickup_centre = pickup_centre_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Centres.update_pickup_centre(pickup_centre, @invalid_attrs)

      assert pickup_centre == Centres.get_pickup_centre!(pickup_centre.id)
    end

    test "delete_pickup_centre/1 deletes the pickup_centre" do
      pickup_centre = pickup_centre_fixture()
      assert {:ok, %PickupCentre{}} = Centres.delete_pickup_centre(pickup_centre)
      assert_raise Ecto.NoResultsError, fn -> Centres.get_pickup_centre!(pickup_centre.id) end
    end
  end
end
