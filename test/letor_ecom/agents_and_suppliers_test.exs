defmodule LetorEcom.AgentsAndSuppliersTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory
  alias LetorEcom.AgentsAndSuppliers
  alias LetorEcom.Control.{EcommerceControl, Location}

  describe "campus_agents" do
    alias LetorEcom.AgentsAndSuppliers.Agent

    test "create_agent/1 with valid data creates a agent" do
      location = Repo.all(Location) |> List.first()
      ecommerce_control = Repo.all(EcommerceControl) |> List.first()

      valid_attrs = %{
        agents_image: "/home/dumadi/Pictures/mypicture.jpeg",
        id_image: "/home/dumadi/Pictures/mypicture.jpeg",
        business_address: "some business_address",
        email: "first_name@gmail.com",
        first_name: "some first_name",
        guarantor_first_name: "some guarantor_first_name",
        guarantor_phone: "08179901928",
        guarantor_residential_address: "some guarantor_residential_address",
        guarantor_last_name: "some guarantor_last_name",
        home_town: "some home_town",
        last_name: "some last_name",
        means_of_id: "some means_of_id",
        nationality: "some nationality",
        phone: "09051182726",
        residential_address: "some residential_address",
        secret_code: "some secret_code",
        state_of_origin: "some state_of_origin",
        status: "some status",
        verified: true,
        location_id: location.id,
        ecommerce_control_id: ecommerce_control.id
      }

      assert {:ok, %{agent: agent}} = AgentsAndSuppliers.create_agent(valid_attrs)

      assert agent.business_address == "some business_address"
      assert agent.email == "first_name@gmail.com"
      assert agent.first_name == "some first_name"
      assert agent.guarantor_first_name == "some guarantor_first_name"
      assert agent.guarantor_phone == "08179901928"
      assert agent.guarantor_residential_address == "some guarantor_residential_address"
      assert agent.guarantor_last_name == "some guarantor_last_name"
      assert agent.home_town == "some home_town"
      assert agent.last_name == "some last_name"
      assert agent.means_of_id == "some means_of_id"
      assert agent.nationality == "some nationality"
      assert agent.phone == "09051182726"
      assert agent.residential_address == "some residential_address"
      assert agent.secret_code == "some secret_code"
      assert agent.state_of_origin == "some state_of_origin"
      assert agent.status == "some status"
      assert agent.verified == true
    end

    test "update_agent/2 with valid data updates the agent" do
      ecommerce_control = build(:ecommerce_control, name: "new_name")
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)

      agent = insert!(:agent, location: location, ecommerce_control: ecommerce_control)

      update_attrs = %{
        business_address: "some updated business_address",
        email: "some updated email",
        first_name: "some updated first_name",
        guarantor_first_name: "some updated guarantor_first_name",
        guarantor_phone: "some updated guarantor_phone",
        guarantor_residential_address: "some updated guarantor_residential_address",
        guarantor_last_name: "some updated guarantor_last_name",
        home_town: "some updated home_town",
        last_name: "some updated last_name",
        means_of_id: "some updated means_of_id",
        nationality: "some updated nationality",
        phone: "some updated phone",
        residential_address: "some updated residential_address",
        secret_code: "some updated secret_code",
        state_of_origin: "some updated state_of_origin",
        status: "some updated status",
        verified: true
      }

      assert {:ok, %Agent{} = agent} = AgentsAndSuppliers.update_agent(agent, update_attrs)

      assert agent.business_address == "some updated business_address"
      assert agent.email == "some updated email"

      assert agent.first_name == "some updated first_name"
      assert agent.guarantor_first_name == "some updated guarantor_first_name"
      assert agent.guarantor_phone == "some updated guarantor_phone"

      assert agent.guarantor_residential_address ==
               "some updated guarantor_residential_address"

      assert agent.guarantor_last_name == "some updated guarantor_last_name"
      assert agent.home_town == "some updated home_town"

      assert agent.last_name == "some updated last_name"
      assert agent.means_of_id == "some updated means_of_id"
      assert agent.nationality == "some updated nationality"
      assert agent.phone == "some updated phone"
      assert agent.residential_address == "some updated residential_address"
      assert agent.secret_code == "some updated secret_code"
      assert agent.state_of_origin == "some updated state_of_origin"
      assert agent.status == "some updated status"
      assert agent.verified == true
    end

    test "delete_agent/1 deletes the agent" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)

      agent = insert!(:agent, location: location, ecommerce_control: ecommerce_control)

      assert {:ok, %Agent{}} = AgentsAndSuppliers.delete_agent(agent)
    end
  end

  describe "suppliers" do
    alias LetorEcom.AgentsAndSuppliers.Supplier

    import LetorEcom.AgentsAndSuppliersFixtures

    @invalid_attrs %{
      address: nil,
      business_name: nil,
      city: nil,
      contact_person: nil,
      country: nil,
      email: nil,
      first_name: nil,
      full_name: nil,
      last_name: nil,
      means_of_id: nil,
      national_supplier: nil,
      phone: nil,
      rc_number: nil,
      regional_supplier: nil,
      state: nil,
      status: nil,
      type: nil,
      verified: nil
    }

    test "list_suppliers/0 returns all suppliers" do
      supplier = supplier_fixture()
      assert AgentsAndSuppliers.list_suppliers() == [supplier]
    end

    test "get_supplier!/1 returns the supplier with given id" do
      supplier = supplier_fixture()
      assert AgentsAndSuppliers.get_supplier!(supplier.id) == supplier
    end

    test "create_supplier/1 with valid data creates a supplier" do
      valid_attrs = %{
        address: "some address",
        business_name: "some business_name",
        city: "some city",
        contact_person: "some contact_person",
        country: "some country",
        email: "some email",
        first_name: "some first_name",
        full_name: "some full_name",
        last_name: "some last_name",
        means_of_id: "some means_of_id",
        national_supplier: true,
        phone: "some phone",
        rc_number: "some rc_number",
        regional_supplier: true,
        state: "some state",
        status: "some status",
        type: "some type",
        verified: true
      }

      assert {:ok, %Supplier{} = supplier} = AgentsAndSuppliers.create_supplier(valid_attrs)
      assert supplier.address == "some address"
      assert supplier.business_name == "some business_name"
      assert supplier.city == "some city"
      assert supplier.contact_person == "some contact_person"
      assert supplier.country == "some country"
      assert supplier.email == "some email"
      assert supplier.first_name == "some first_name"
      assert supplier.full_name == "some full_name"
      assert supplier.last_name == "some last_name"
      assert supplier.means_of_id == "some means_of_id"
      assert supplier.national_supplier == true
      assert supplier.phone == "some phone"
      assert supplier.rc_number == "some rc_number"
      assert supplier.regional_supplier == true
      assert supplier.state == "some state"
      assert supplier.status == "some status"
      assert supplier.type == "some type"
      assert supplier.verified == true
    end

    test "create_supplier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AgentsAndSuppliers.create_supplier(@invalid_attrs)
    end

    test "update_supplier/2 with valid data updates the supplier" do
      supplier = supplier_fixture()

      update_attrs = %{
        address: "some updated address",
        business_name: "some updated business_name",
        city: "some updated city",
        contact_person: "some updated contact_person",
        country: "some updated country",
        email: "some updated email",
        first_name: "some updated first_name",
        full_name: "some updated full_name",
        last_name: "some updated last_name",
        means_of_id: "some updated means_of_id",
        national_supplier: false,
        phone: "some updated phone",
        rc_number: "some updated rc_number",
        regional_supplier: false,
        state: "some updated state",
        status: "some updated status",
        type: "some updated type",
        verified: false
      }

      assert {:ok, %Supplier{} = supplier} =
               AgentsAndSuppliers.update_supplier(supplier, update_attrs)

      assert supplier.address == "some updated address"
      assert supplier.business_name == "some updated business_name"
      assert supplier.city == "some updated city"
      assert supplier.contact_person == "some updated contact_person"
      assert supplier.country == "some updated country"
      assert supplier.email == "some updated email"
      assert supplier.first_name == "some updated first_name"
      assert supplier.full_name == "some updated full_name"
      assert supplier.last_name == "some updated last_name"
      assert supplier.means_of_id == "some updated means_of_id"
      assert supplier.national_supplier == false
      assert supplier.phone == "some updated phone"
      assert supplier.rc_number == "some updated rc_number"
      assert supplier.regional_supplier == false
      assert supplier.state == "some updated state"
      assert supplier.status == "some updated status"
      assert supplier.type == "some updated type"
      assert supplier.verified == false
    end

    test "update_supplier/2 with invalid data returns error changeset" do
      supplier = supplier_fixture()

      assert {:error, %Ecto.Changeset{}} =
               AgentsAndSuppliers.update_supplier(supplier, @invalid_attrs)

      assert supplier == AgentsAndSuppliers.get_supplier!(supplier.id)
    end

    test "delete_supplier/1 deletes the supplier" do
      supplier = supplier_fixture()
      assert {:ok, %Supplier{}} = AgentsAndSuppliers.delete_supplier(supplier)
      assert_raise Ecto.NoResultsError, fn -> AgentsAndSuppliers.get_supplier!(supplier.id) end
    end

    test "change_supplier/1 returns a supplier changeset" do
      supplier = supplier_fixture()
      assert %Ecto.Changeset{} = AgentsAndSuppliers.change_supplier(supplier)
    end
  end
end
