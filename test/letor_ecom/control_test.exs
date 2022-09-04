defmodule LetorEcom.ControlTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory

  alias LetorEcom.Control

  describe "ecommerce_controls" do
    alias LetorEcom.Control.EcommerceControl

    @invalid_attrs %{country: nil, name: nil, region: nil}

    test "create_ecommerce_control/1 with valid data creates a ecommerce_control" do
      valid_attrs = %{
        country: "some country",
        name: "some name",
        region: "some region"
      }

      assert {:ok, %EcommerceControl{} = ecommerce_control} =
               Control.create_ecommerce_control(valid_attrs)

      assert ecommerce_control.country == "some country"
      assert ecommerce_control.name == "some name"
      assert ecommerce_control.region == "some region"
    end

    test "create_ecommerce_control/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_ecommerce_control(@invalid_attrs)
    end

    test "update_ecommerce_control/2 with valid data updates the ecommerce_control" do
      ecommerce_control = ecommerce_control_fixture()

      update_attrs = %{
        country: "some updated country",
        name: "some updated name",
        region: "some updated region"
      }

      assert {:ok, %EcommerceControl{} = ecommerce_control} =
               Control.update_ecommerce_control(ecommerce_control, update_attrs)

      assert ecommerce_control.country == "some updated country"
      assert ecommerce_control.name == "some updated name"
      assert ecommerce_control.region == "some updated region"
    end

    test "update_ecommerce_control/2 with invalid data returns error changeset" do
      ecommerce_control = ecommerce_control_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Control.update_ecommerce_control(ecommerce_control, @invalid_attrs)
    end

    # test "delete_ecommerce_control/1 deletes the ecommerce_control" do
    # ecommerce_control = Repo.all(EcommerceControl) |> List.first()
    # assert {:ok, %EcommerceControl{}} = Control.delete_ecommerce_control(ecommerce_control)
    # end
  end

  describe "location" do
    alias LetorEcom.Centres.PickupCentre
    alias LetorEcom.Control.Location

    @invalid_attrs %{
      city: nil,
      country: nil,
      location_area: nil,
      location_coordinates: nil,
      postal_code: nil,
      state: nil,
      pickup_centre_id: nil
    }

    test "create_location/1 with valid data creates a location" do
      pickup_centre = pickup_centre_fixture()

      valid_attrs = %{
        city: "some city",
        country: "some country",
        location_area: "some location_area",
        location_coordinates: %Geo.Point{
          coordinates: {4.833813967530579, 7.0250130040393675},
          srid: 4326
        },
        postal_code: "some postal_code",
        state: "some state",
        pickup_centre_id: pickup_centre.id
      }

      assert {:ok, %Location{} = location} = Control.create_location(valid_attrs)
      assert location.city == "some city"
      assert location.country == "some country"
      assert location.location_area == "some location_area"

      assert location.location_coordinates == %Geo.Point{
               coordinates: {4.833813967530579, 7.0250130040393675},
               srid: 4326
             }

      assert location.postal_code == "some postal_code"
      assert location.state == "some state"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()

      update_attrs = %{
        city: "some updated city",
        country: "some updated country",
        location_area: "some updated location_area",
        location_coordinates: %Geo.Point{
          coordinates: {4.833813967530579, 7.0250130040393675},
          srid: 4326
        },
        postal_code: "some updated postal_code",
        state: "some updated state"
      }

      assert {:ok, %Location{} = location} = Control.update_location(location, update_attrs)
      assert location.city == "some updated city"
      assert location.country == "some updated country"
      assert location.location_area == "some updated location_area"
      assert location.postal_code == "some updated postal_code"
      assert location.state == "some updated state"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Control.update_location(location, @invalid_attrs)
      assert location == Control.get_location!(location.id)
    end

    # test "delete_location/1 deletes the location" do
    # location = Repo.all(Location) |> List.first()
    # assert {:ok, %Location{}} = Control.delete_location(location)
    # end
  end
end
