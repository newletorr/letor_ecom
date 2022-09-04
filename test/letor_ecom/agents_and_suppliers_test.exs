defmodule LetorEcom.AgentsAndSuppliersTest do
  use LetorEcom.DataCase, async: true
  # import LetorEcom.Factory
  alias LetorEcom.AgentsAndSuppliers
  alias LetorEcom.Control.{EcommerceControl, Location}

  describe "suppliers" do
    alias LetorEcom.AgentsAndSuppliers.Supplier

    # AgentsAndSuppliersFixtures
    import LetorEcom.Factory

    @invalid_attrs %{
      address: nil,
      business_name: nil,
      city: nil,
      contact_person: nil,
      country: nil,
      email: "FAYVOUR@EMAIL.COM",
      first_name: nil,
      full_name: nil,
      last_name: nil,
      means_of_id: nil,
      national_supplier: true,
      phone: nil,
      rc_number: nil,
      regional_supplier: true,
      state: nil,
      status: nil,
      type: nil,
      verified: true
    }

    # test "list_suppliers/0 returns all suppliers" do
    # supplier = Repo.all(Supplier) |> List.first()
    # assert AgentsAndSuppliers.list_suppliers() == [supplier]
    # end

    # test "search_supplier!/1 returns the supplier with given id" do
    # supplier = supplier_fixture()
    # assert AgentsAndSuppliers.search_supplier!(supplier.id) == supplier
    # end

    test "create_supplier/1 with valid data creates a supplier" do
      valid_attrs = %{
        address: "no 4 alejor road, onne",
        business_name: nil,
        city: "some city",
        #contact_person: "some contact person",
        country: "some country",
        email: "emmy@email.com",
        first_name: "first_name",
        #full_name: first_name <> " " <> last_name,
        last_name: "last_name",
        means_of_id: "some means_of_id",
        national_supplier: true,
        phone: "08037236344",
       # rc_number: "some rc_number",
        regional_supplier: true,
        state: "some state",
        status: "some status",
        type: "some type",
        verified: true,
        id_image: "some id image"
      }

      assert {:ok, %Supplier{} = supplier} = AgentsAndSuppliers.create_supplier(valid_attrs)
      assert supplier.address == "no 4 alejor road, onne"
      #assert supplier.business_name == "some business_name"
      assert supplier.city == "some city"
     # assert supplier.contact_person == "some contact person"
      assert supplier.country == "some country"
      assert supplier.email == "emmy@email.com"
      assert supplier.first_name == "first_name"
      #assert supplier.full_name == "first_name <> " " <> last_name"
      assert supplier.last_name == "last_name"
      assert supplier.means_of_id == "some means_of_id"
      assert supplier.national_supplier == true
      assert supplier.phone == "08037236344"
      #assert supplier.rc_number == "some rc_number"
      assert supplier.regional_supplier == true
      assert supplier.state == "some state"
      assert supplier.status == "some status"
      assert supplier.type == "some type"
      assert supplier.verified == true
      assert supplier.id_image == "some id image"
    end

    test "create_supplier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AgentsAndSuppliers.create_supplier(@invalid_attrs)
    end

    test "update_supplier/2 with valid data updates the supplier" do
      supplier = supplier_fixture()

      update_attrs = %{
        address: "some updated address",
        business_name: "business_name",
        city: "some updated city",
        contact_person: "some updated contact_person",
        country: "some updated country",
        email: "beauty@email.com",
        first_name: "first_name",
        full_name: "full_name",
        last_name: "last_name",
        means_of_id: "some updated means_of_id",
        national_supplier: false,
        phone: "08177600425",
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
      assert supplier.business_name == "business_name"
      assert supplier.city == "some updated city"
      assert supplier.contact_person == "some updated contact_person"
      assert supplier.country == "some updated country"
      assert supplier.email == "beauty@email.com"
      assert supplier.first_name == "first_name"
      # assert supplier.full_name == first_name <> " " <> last_name
      assert supplier.last_name == "last_name"
      assert supplier.means_of_id == "some updated means_of_id"
      assert supplier.national_supplier == false
      assert supplier.phone == "08177600425"
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

    # test "change_supplier/1 returns a supplier changeset" do
    # supplier = Repo.all(Supplier) |> List.first()
    # assert %Ecto.Changeset{} = AgentsAndSuppliers.change_supplier(supplier)
    # end
  end
end
