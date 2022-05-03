defmodule LetorEcom.ControlTest do
  use LetorEcom.DataCase
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

      assert {:error, %Ecto.Changeset{}} =
               Control.update_ecommerce_control(ecommerce_control, @invalid_attrs)

      assert ecommerce_control == Control.get_ecommerce_control!(ecommerce_control.id)
    end

    test "delete_ecommerce_control/1 deletes the ecommerce_control" do
      assert {:ok, %EcommerceControl{}} = Control.delete_ecommerce_control(ecommerce_control)

      assert_raise Ecto.NoResultsError, fn ->
        Control.get_ecommerce_control!(ecommerce_control.id)
      end
    end
  end

  describe "location" do
    alias LetorEcom.Control.Location



    @invalid_attrs %{
      city: nil,
      country: nil,
      location_area: nil,
      location_coordinates: nil,
      postal_code: nil,
      state: nil
    }



    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{
        city: "some city",
        country: "some country",
        location_area: "some location_area",
        location_coordinates: "some location_coordinates",
        postal_code: "some postal_code",
        state: "some state"
      }

      assert {:ok, %Location{} = location} = Control.create_location(valid_attrs)
      assert location.city == "some city"
      assert location.country == "some country"
      assert location.location_area == "some location_area"
      assert location.location_coordinates == "some location_coordinates"
      assert location.postal_code == "some postal_code"
      assert location.state == "some state"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do

      update_attrs = %{
        city: "some updated city",
        country: "some updated country",
        location_area: "some updated location_area",
        location_coordinates: "some updated location_coordinates",
        postal_code: "some updated postal_code",
        state: "some updated state"
      }

      assert {:ok, %Location{} = location} = Control.update_location(location, update_attrs)
      assert location.city == "some updated city"
      assert location.country == "some updated country"
      assert location.location_area == "some updated location_area"
      assert location.location_coordinates == "some updated location_coordinates"
      assert location.postal_code == "some updated postal_code"
      assert location.state == "some updated state"
    end

    test "update_location/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.update_location(location, @invalid_attrs)
      assert location == Control.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      assert {:ok, %Location{}} = Control.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Control.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      assert %Ecto.Changeset{} = Control.change_location(location)
    end
  end

  describe "covered_institutions" do
    alias LetorEcom.Control.CoveredInstitution



    @invalid_attrs %{campus_name: nil, name: nil}


    test "create_covered_institution/1 with valid data creates a covered_institution" do
      valid_attrs = %{campus_name: "some campus_name", name: "some name"}

      assert {:ok, %CoveredInstitution{} = covered_institution} =
               Control.create_covered_institution(valid_attrs)

      assert covered_institution.campus_name == "some campus_name"
      assert covered_institution.name == "some name"
    end

    test "create_covered_institution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_covered_institution(@invalid_attrs)
    end

    test "update_covered_institution/2 with valid data updates the covered_institution" do
      update_attrs = %{campus_name: "some updated campus_name", name: "some updated name"}

      assert {:ok, %CoveredInstitution{} = covered_institution} =
               Control.update_covered_institution(covered_institution, update_attrs)

      assert covered_institution.campus_name == "some updated campus_name"
      assert covered_institution.name == "some updated name"
    end

    test "update_covered_institution/2 with invalid data returns error changeset" do

      assert {:error, %Ecto.Changeset{}} =
               Control.update_covered_institution(covered_institution, @invalid_attrs)

      assert covered_institution == Control.get_covered_institution!(covered_institution.id)
    end

    test "delete_covered_institution/1 deletes the covered_institution" do

      assert {:ok, %CoveredInstitution{}} =
               Control.delete_covered_institution(covered_institution)

      assert_raise Ecto.NoResultsError, fn ->
        Control.get_covered_institution!(covered_institution.id)
      end
    end

   
  end
end
