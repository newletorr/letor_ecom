defmodule LetorEcom.HumanResourceTest do
  use LetorEcom.DataCase
  import LetorEcom.Factory

  alias LetorEcom.HumanResource

  describe "staff" do
    alias LetorEcom.HumanResource.Staff

    import LetorEcom.HumanResourceFixtures

    @invalid_attrs %{
      country: nil,
      date_employed: nil,
      designation: nil,
      email: nil,
      employment_status: nil,
      first_name: nil,
      full_name: nil,
      guarantor_address: nil,
      guarantor_name: nil,
      guarantor_phone: nil,
      home_town: nil,
      id_code: nil,
      id_number: nil,
      last_name: nil,
      lga: nil,
      means_of_id: nil,
      phone: nil,
      residential_address: nil,
      state_of_origin: nil
    }

    test "list_staff/0 returns all staff" do
      staff = staff_fixture()
      assert HumanResource.list_staff() == [staff]
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = staff_fixture()
      assert HumanResource.get_staff!(staff.id) == staff
    end

    test "create_staff/1 with valid data creates a staff" do
      valid_attrs = %{
        country: "some country",
        date_employed: "some date_employed",
        designation: "some designation",
        email: "some email",
        employment_status: "some employment_status",
        first_name: "some first_name",
        full_name: "some full_name",
        guarantor_address: "some guarantor_address",
        guarantor_name: "some guarantor_name",
        guarantor_phone: "some guarantor_phone",
        home_town: "some home_town",
        id_code: "some id_code",
        id_number: "some id_number",
        last_name: "some last_name",
        lga: "some lga",
        means_of_id: "some means_of_id",
        phone: "some phone",
        residential_address: "some residential_address",
        state_of_origin: "some state_of_origin"
      }

      assert {:ok, %Staff{} = staff} = HumanResource.create_staff(valid_attrs)
      assert staff.country == "some country"
      assert staff.date_employed == "some date_employed"
      assert staff.designation == "some designation"
      assert staff.email == "some email"
      assert staff.employment_status == "some employment_status"
      assert staff.first_name == "some first_name"
      assert staff.full_name == "some full_name"
      assert staff.guarantor_address == "some guarantor_address"
      assert staff.guarantor_name == "some guarantor_name"
      assert staff.guarantor_phone == "some guarantor_phone"
      assert staff.home_town == "some home_town"
      assert staff.id_code == "some id_code"
      assert staff.id_number == "some id_number"
      assert staff.last_name == "some last_name"
      assert staff.lga == "some lga"
      assert staff.means_of_id == "some means_of_id"
      assert staff.phone == "some phone"
      assert staff.residential_address == "some residential_address"
      assert staff.state_of_origin == "some state_of_origin"
    end

    test "create_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HumanResource.create_staff(@invalid_attrs)
    end

    test "update_staff/2 with valid data updates the staff" do
      staff = staff_fixture()

      update_attrs = %{
        country: "some updated country",
        date_employed: "some updated date_employed",
        designation: "some updated designation",
        email: "some updated email",
        employment_status: "some updated employment_status",
        first_name: "some updated first_name",
        full_name: "some updated full_name",
        guarantor_address: "some updated guarantor_address",
        guarantor_name: "some updated guarantor_name",
        guarantor_phone: "some updated guarantor_phone",
        home_town: "some updated home_town",
        id_code: "some updated id_code",
        id_number: "some updated id_number",
        last_name: "some updated last_name",
        lga: "some updated lga",
        means_of_id: "some updated means_of_id",
        phone: "some updated phone",
        residential_address: "some updated residential_address",
        state_of_origin: "some updated state_of_origin"
      }

      assert {:ok, %Staff{} = staff} = HumanResource.update_staff(staff, update_attrs)
      assert staff.country == "some updated country"
      assert staff.date_employed == "some updated date_employed"
      assert staff.designation == "some updated designation"
      assert staff.email == "some updated email"
      assert staff.employment_status == "some updated employment_status"
      assert staff.first_name == "some updated first_name"
      assert staff.full_name == "some updated full_name"
      assert staff.guarantor_address == "some updated guarantor_address"
      assert staff.guarantor_name == "some updated guarantor_name"
      assert staff.guarantor_phone == "some updated guarantor_phone"
      assert staff.home_town == "some updated home_town"
      assert staff.id_code == "some updated id_code"
      assert staff.id_number == "some updated id_number"
      assert staff.last_name == "some updated last_name"
      assert staff.lga == "some updated lga"
      assert staff.means_of_id == "some updated means_of_id"
      assert staff.phone == "some updated phone"
      assert staff.residential_address == "some updated residential_address"
      assert staff.state_of_origin == "some updated state_of_origin"
    end

    test "update_staff/2 with invalid data returns error changeset" do
      staff = staff_fixture()
      assert {:error, %Ecto.Changeset{}} = HumanResource.update_staff(staff, @invalid_attrs)
      assert staff == HumanResource.get_staff!(staff.id)
    end

    test "delete_staff/1 deletes the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{}} = HumanResource.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> HumanResource.get_staff!(staff.id) end
    end

    test "change_staff/1 returns a staff changeset" do
      staff = staff_fixture()
      assert %Ecto.Changeset{} = HumanResource.change_staff(staff)
    end
  end

  describe "drivers" do
    alias LetorEcom.HumanResource.Driver

    import LetorEcom.HumanResourceFixtures

    @invalid_attrs %{email: nil, name: nil, phone: nil, status: nil}

    test "list_drivers/0 returns all drivers" do
      driver = driver_fixture()
      assert HumanResource.list_drivers() == [driver]
    end

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert HumanResource.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      valid_attrs = %{
        email: "some email",
        name: "some name",
        phone: "some phone",
        status: "some status"
      }

      assert {:ok, %Driver{} = driver} = HumanResource.create_driver(valid_attrs)
      assert driver.email == "some email"
      assert driver.name == "some name"
      assert driver.phone == "some phone"
      assert driver.status == "some status"
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HumanResource.create_driver(@invalid_attrs)
    end

    test "update_driver/2 with valid data updates the driver" do
      driver = driver_fixture()

      update_attrs = %{
        email: "some updated email",
        name: "some updated name",
        phone: "some updated phone",
        status: "some updated status"
      }

      assert {:ok, %Driver{} = driver} = HumanResource.update_driver(driver, update_attrs)
      assert driver.email == "some updated email"
      assert driver.name == "some updated name"
      assert driver.phone == "some updated phone"
      assert driver.status == "some updated status"
    end

    test "update_driver/2 with invalid data returns error changeset" do
      driver = driver_fixture()
      assert {:error, %Ecto.Changeset{}} = HumanResource.update_driver(driver, @invalid_attrs)
      assert driver == HumanResource.get_driver!(driver.id)
    end

    test "delete_driver/1 deletes the driver" do
      driver = driver_fixture()
      assert {:ok, %Driver{}} = HumanResource.delete_driver(driver)
      assert_raise Ecto.NoResultsError, fn -> HumanResource.get_driver!(driver.id) end
    end

    test "change_driver/1 returns a driver changeset" do
      driver = driver_fixture()
      assert %Ecto.Changeset{} = HumanResource.change_driver(driver)
    end
  end

  describe "staff_postings" do
    alias LetorEcom.HumanResource.StaffPosting

    import LetorEcom.HumanResourceFixtures

    @invalid_attrs %{date_posted: nil, previous_posting: nil}

    test "list_staff_postings/0 returns all staff_postings" do
      staff_posting = staff_posting_fixture()
      assert HumanResource.list_staff_postings() == [staff_posting]
    end

    test "get_staff_posting!/1 returns the staff_posting with given id" do
      staff_posting = staff_posting_fixture()
      assert HumanResource.get_staff_posting!(staff_posting.id) == staff_posting
    end

    test "create_staff_posting/1 with valid data creates a staff_posting" do
      valid_attrs = %{date_posted: ~D[2022-04-03], previous_posting: "some previous_posting"}

      assert {:ok, %StaffPosting{} = staff_posting} =
               HumanResource.create_staff_posting(valid_attrs)

      assert staff_posting.date_posted == ~D[2022-04-03]
      assert staff_posting.previous_posting == "some previous_posting"
    end

    test "create_staff_posting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HumanResource.create_staff_posting(@invalid_attrs)
    end

    test "update_staff_posting/2 with valid data updates the staff_posting" do
      staff_posting = staff_posting_fixture()

      update_attrs = %{
        date_posted: ~D[2022-04-04],
        previous_posting: "some updated previous_posting"
      }

      assert {:ok, %StaffPosting{} = staff_posting} =
               HumanResource.update_staff_posting(staff_posting, update_attrs)

      assert staff_posting.date_posted == ~D[2022-04-04]
      assert staff_posting.previous_posting == "some updated previous_posting"
    end

    test "update_staff_posting/2 with invalid data returns error changeset" do
      staff_posting = staff_posting_fixture()

      assert {:error, %Ecto.Changeset{}} =
               HumanResource.update_staff_posting(staff_posting, @invalid_attrs)

      assert staff_posting == HumanResource.get_staff_posting!(staff_posting.id)
    end

    test "delete_staff_posting/1 deletes the staff_posting" do
      staff_posting = staff_posting_fixture()
      assert {:ok, %StaffPosting{}} = HumanResource.delete_staff_posting(staff_posting)

      assert_raise Ecto.NoResultsError, fn ->
        HumanResource.get_staff_posting!(staff_posting.id)
      end
    end

    test "change_staff_posting/1 returns a staff_posting changeset" do
      staff_posting = staff_posting_fixture()
      assert %Ecto.Changeset{} = HumanResource.change_staff_posting(staff_posting)
    end
  end
end
