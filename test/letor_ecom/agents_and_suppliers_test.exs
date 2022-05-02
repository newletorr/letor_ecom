defmodule LetorEcom.AgentsAndSuppliersTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory
  alias LetorEcom.AgentsAndSuppliers
  alias LetorEcom.Control.{EcommerceControl, Location}

  describe "campus_agents" do
    alias LetorEcom.AgentsAndSuppliers.CampusAgent

    test "create_campus_agent/1 with valid data creates a campus_agent" do
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

      assert {:ok, %{campus_agent: campus_agent}} =
               AgentsAndSuppliers.create_campus_agent(valid_attrs)

      assert campus_agent.business_address == "some business_address"
      assert campus_agent.email == "first_name@gmail.com"
      assert campus_agent.first_name == "some first_name"
      assert campus_agent.guarantor_first_name == "some guarantor_first_name"
      assert campus_agent.guarantor_phone == "08179901928"
      assert campus_agent.guarantor_residential_address == "some guarantor_residential_address"
      assert campus_agent.guarantor_last_name == "some guarantor_last_name"
      assert campus_agent.home_town == "some home_town"
      assert campus_agent.last_name == "some last_name"
      assert campus_agent.means_of_id == "some means_of_id"
      assert campus_agent.nationality == "some nationality"
      assert campus_agent.phone == "09051182726"
      assert campus_agent.residential_address == "some residential_address"
      assert campus_agent.secret_code == "some secret_code"
      assert campus_agent.state_of_origin == "some state_of_origin"
      assert campus_agent.status == "some status"
      assert campus_agent.verified == true
    end

    test "update_campus_agent/2 with valid data updates the campus_agent" do
      ecommerce_control = build(:ecommerce_control, name: "new_name")
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)

      campus_agent =
        insert!(:campus_agent, location: location, ecommerce_control: ecommerce_control)

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

      assert {:ok, %CampusAgent{} = campus_agent} =
               AgentsAndSuppliers.update_campus_agent(campus_agent, update_attrs)

      assert campus_agent.business_address == "some updated business_address"
      assert campus_agent.email == "some updated email"

      assert campus_agent.first_name == "some updated first_name"
      assert campus_agent.guarantor_first_name == "some updated guarantor_first_name"
      assert campus_agent.guarantor_phone == "some updated guarantor_phone"

      assert campus_agent.guarantor_residential_address ==
               "some updated guarantor_residential_address"

      assert campus_agent.guarantor_last_name == "some updated guarantor_last_name"
      assert campus_agent.home_town == "some updated home_town"

      assert campus_agent.last_name == "some updated last_name"
      assert campus_agent.means_of_id == "some updated means_of_id"
      assert campus_agent.nationality == "some updated nationality"
      assert campus_agent.phone == "some updated phone"
      assert campus_agent.residential_address == "some updated residential_address"
      assert campus_agent.secret_code == "some updated secret_code"
      assert campus_agent.state_of_origin == "some updated state_of_origin"
      assert campus_agent.status == "some updated status"
      assert campus_agent.verified == true
    end

    test "delete_campus_agent/1 deletes the campus_agent" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)

      campus_agent =
        insert!(:campus_agent, location: location, ecommerce_control: ecommerce_control)

      assert {:ok, %CampusAgent{}} = AgentsAndSuppliers.delete_campus_agent(campus_agent)
    end
  end
end
