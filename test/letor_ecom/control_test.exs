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
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

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
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

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
      pickup_centre = Repo.all(PickupCentre) |> List.first()

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
      location = Repo.all(Location) |> List.first()

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
      location = Repo.all(Location) |> List.first()
      assert {:error, %Ecto.Changeset{}} = Control.update_location(location, @invalid_attrs)
      assert location == Control.get_location!(location.id)
    end

    # test "delete_location/1 deletes the location" do
    # location = Repo.all(Location) |> List.first()
    # assert {:ok, %Location{}} = Control.delete_location(location)
    # end
  end

  describe "covered_institutions" do
    alias LetorEcom.Control.{CoveredInstitution, EcommerceControl, Location}

    @invalid_attrs %{campus_name: nil, name: nil, location_id: nil, ecommerce_control_id: nil}

    test "create_covered_institution/1 with valid data creates a covered_institution" do
      location = Repo.all(Location) |> List.first()
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

      valid_attrs = %{
        campus_name: "some campus_name",
        name: "some name",
        location_id: location.id,
        ecommerce_control_id: ecommerce_control.id
      }

      assert {:ok, %CoveredInstitution{} = covered_institution} =
               Control.create_covered_institution(valid_attrs)

      assert covered_institution.campus_name == "some campus_name"
      assert covered_institution.name == "some name"
    end

    test "create_covered_institution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_covered_institution(@invalid_attrs)
    end

    test "update_covered_institution/2 with valid data updates the covered_institution" do
      covered_institution = Repo.all(CoveredInstitution) |> List.first()
      update_attrs = %{campus_name: "some updated campus_name", name: "some updated name"}

      assert {:ok, %CoveredInstitution{} = covered_institution} =
               Control.update_covered_institution(covered_institution, update_attrs)

      assert covered_institution.campus_name == "some updated campus_name"
      assert covered_institution.name == "some updated name"
    end

    test "update_covered_institution/2 with invalid data returns error changeset" do
      covered_institution = Repo.all(CoveredInstitution) |> List.first()

      assert {:error, %Ecto.Changeset{}} =
               Control.update_covered_institution(covered_institution, @invalid_attrs)
    end

    # test "delete_covered_institution/1 deletes the covered_institution" do
    # covered_institution = Repo.all(CoveredInstitution) |> List.first()

    # assert {:ok, %CoveredInstitution{}} =
    #        Control.delete_covered_institution(covered_institution)
    # end
  end
end
