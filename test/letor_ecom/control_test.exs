defmodule LetorEcom.ControlTest do
  use LetorEcom.DataCase

  alias LetorEcom.Control

  describe "centre_code" do
    alias LetorEcom.Control.CentreCode

    import LetorEcom.ControlFixtures

    @invalid_attrs %{centre_name: nil}

    test "list_centre_code/0 returns all centre_code" do
      centre_code = centre_code_fixture()
      assert Control.list_centre_code() == [centre_code]
    end

    test "get_centre_code!/1 returns the centre_code with given id" do
      centre_code = centre_code_fixture()
      assert Control.get_centre_code!(centre_code.id) == centre_code
    end

    test "create_centre_code/1 with valid data creates a centre_code" do
      valid_attrs = %{centre_name: "some centre_name"}

      assert {:ok, %CentreCode{} = centre_code} = Control.create_centre_code(valid_attrs)
      assert centre_code.centre_name == "some centre_name"
    end

    test "create_centre_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_centre_code(@invalid_attrs)
    end

    test "update_centre_code/2 with valid data updates the centre_code" do
      centre_code = centre_code_fixture()

      update_attrs = %{
        centre_name: "some updated centre_name"
      }

      assert {:ok, %CentreCode{} = centre_code} =
               Control.update_centre_code(centre_code, update_attrs)

      assert centre_code.centre_name == "some updated centre_name"
    end

    test "update_centre_code/2 with invalid data returns error changeset" do
      centre_code = centre_code_fixture()
      assert {:error, %Ecto.Changeset{}} = Control.update_centre_code(centre_code, @invalid_attrs)
      assert centre_code == Control.get_centre_code!(centre_code.id)
    end

    test "delete_centre_code/1 deletes the centre_code" do
      centre_code = centre_code_fixture()
      assert {:ok, %CentreCode{}} = Control.delete_centre_code(centre_code)
      assert_raise Ecto.NoResultsError, fn -> Control.get_centre_code!(centre_code.id) end
    end
  end

  describe "ecommerce_controls" do
    alias LetorEcom.Control.EcommerceControl

    import LetorEcom.ControlFixtures

    @invalid_attrs %{country: nil, name: nil, region: nil, centre_code_id: nil}

    test "list_ecommerce_controls/0 returns all ecommerce_controls" do
      ecommerce_control = ecommerce_control_fixture()
      assert Control.list_ecommerce_controls() == [ecommerce_control]
    end

    test "get_ecommerce_control!/1 returns the ecommerce_control with given id" do
      ecommerce_control = ecommerce_control_fixture()
      assert Control.get_ecommerce_control!(ecommerce_control.id) == ecommerce_control
    end

    test "create_ecommerce_control/1 with valid data creates a ecommerce_control" do
      centre_code = centre_code_fixture()

      valid_attrs = %{
        country: "some country",
        name: "some name",
        region: "some region",
        centre_code_id: centre_code.id
      }

      assert {:ok, %EcommerceControl{} = ecommerce_control} =
               Control.create_ecommerce_control(valid_attrs)

      assert ecommerce_control.country == "some country"
      assert ecommerce_control.name == "some name"
      assert ecommerce_control.region == "some region"
      assert ecommerce_control.centre_code_id == centre_code.id
    end

    test "create_ecommerce_control/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Control.create_ecommerce_control(@invalid_attrs)
    end

    test "update_ecommerce_control/2 with valid data updates the ecommerce_control" do
      centre_code = centre_code_fixture()
      ecommerce_control = ecommerce_control_fixture()

      update_attrs = %{
        country: "some updated country",
        name: "some updated name",
        region: "some updated region",
        centre_code_id: centre_code.id
      }

      assert {:ok, %EcommerceControl{} = ecommerce_control} =
               Control.update_ecommerce_control(ecommerce_control, update_attrs)

      assert ecommerce_control.country == "some updated country"
      assert ecommerce_control.name == "some updated name"
      assert ecommerce_control.region == "some updated region"
      assert ecommerce_control.centre_code_id == centre_code.id
    end

    test "update_ecommerce_control/2 with invalid data returns error changeset" do
      ecommerce_control = ecommerce_control_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Control.update_ecommerce_control(ecommerce_control, @invalid_attrs)

      assert ecommerce_control == Control.get_ecommerce_control!(ecommerce_control.id)
    end

    test "delete_ecommerce_control/1 deletes the ecommerce_control" do
      ecommerce_control = ecommerce_control_fixture()
      assert {:ok, %EcommerceControl{}} = Control.delete_ecommerce_control(ecommerce_control)

      assert_raise Ecto.NoResultsError, fn ->
        Control.get_ecommerce_control!(ecommerce_control.id)
      end
    end
  end
end
