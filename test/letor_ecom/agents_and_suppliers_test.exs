defmodule LetorEcom.AgentsAndSuppliersTest do
  use LetorEcom.DataCase

  alias LetorEcom.AgentsAndSuppliers

  describe "campus_agents" do
    alias LetorEcom.AgentsAndSuppliers.CampusAgent

    import LetorEcom.AgentsAndSuppliersFixtures

    @invalid_attrs %{
      business_address: nil,
      email: nil,
      first_name: nil,
      guarantor_first_name: nil,
      guarantor_phone: nil,
      guarantor_residential_address: nil,
      guarantor_second_name: nil,
      home_town: nil,
      id_image: nil,
      last_name: nil,
      means_of_id: nil,
      nationality: nil,
      phone: nil,
      residential_address: nil,
      secret_code: nil,
      state_of_origin: nil,
      status: nil,
      verified: nil
    }

    test "list_campus_agents/0 returns all campus_agents" do
      campus_agent = campus_agent_fixture()
      assert AgentsAndSuppliers.list_campus_agents() == [campus_agent]
    end

    test "get_campus_agent!/1 returns the campus_agent with given id" do
      campus_agent = campus_agent_fixture()
      assert AgentsAndSuppliers.get_campus_agent!(campus_agent.id) == campus_agent
    end

    test "create_campus_agent/1 with valid data creates a campus_agent" do
      valid_attrs = %{
        business_address: "some business_address",
        email: "some email",
        first_name: "some first_name",
        guarantor_first_name: "some guarantor_first_name",
        guarantor_phone: "some guarantor_phone",
        guarantor_residential_address: "some guarantor_residential_address",
        guarantor_second_name: "some guarantor_second_name",
        home_town: "some home_town",
        id_image: "some id_image",
        last_name: "some last_name",
        means_of_id: "some means_of_id",
        nationality: "some nationality",
        phone: "some phone",
        residential_address: "some residential_address",
        secret_code: "some secret_code",
        state_of_origin: "some state_of_origin",
        status: "some status",
        verified: "some verified"
      }

      assert {:ok, %CampusAgent{} = campus_agent} =
               AgentsAndSuppliers.create_campus_agent(valid_attrs)

      assert campus_agent.business_address == "some business_address"
      assert campus_agent.email == "some email"
      assert campus_agent.first_name == "some first_name"
      assert campus_agent.guarantor_first_name == "some guarantor_first_name"
      assert campus_agent.guarantor_phone == "some guarantor_phone"
      assert campus_agent.guarantor_residential_address == "some guarantor_residential_address"
      assert campus_agent.guarantor_second_name == "some guarantor_second_name"
      assert campus_agent.home_town == "some home_town"
      assert campus_agent.id_image == "some id_image"
      assert campus_agent.last_name == "some last_name"
      assert campus_agent.means_of_id == "some means_of_id"
      assert campus_agent.nationality == "some nationality"
      assert campus_agent.phone == "some phone"
      assert campus_agent.residential_address == "some residential_address"
      assert campus_agent.secret_code == "some secret_code"
      assert campus_agent.state_of_origin == "some state_of_origin"
      assert campus_agent.status == "some status"
      assert campus_agent.verified == "some verified"
    end

    test "create_campus_agent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AgentsAndSuppliers.create_campus_agent(@invalid_attrs)
    end

    test "update_campus_agent/2 with valid data updates the campus_agent" do
      campus_agent = campus_agent_fixture()

      update_attrs = %{
        business_address: "some updated business_address",
        email: "some updated email",
        first_name: "some updated first_name",
        guarantor_first_name: "some updated guarantor_first_name",
        guarantor_phone: "some updated guarantor_phone",
        guarantor_residential_address: "some updated guarantor_residential_address",
        guarantor_second_name: "some updated guarantor_second_name",
        home_town: "some updated home_town",
        id_image: "some updated id_image",
        last_name: "some updated last_name",
        means_of_id: "some updated means_of_id",
        nationality: "some updated nationality",
        phone: "some updated phone",
        residential_address: "some updated residential_address",
        secret_code: "some updated secret_code",
        state_of_origin: "some updated state_of_origin",
        status: "some updated status",
        verified: "some updated verified"
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

      assert campus_agent.guarantor_second_name == "some updated guarantor_second_name"
      assert campus_agent.home_town == "some updated home_town"
      assert campus_agent.id_image == "some updated id_image"
      assert campus_agent.last_name == "some updated last_name"
      assert campus_agent.means_of_id == "some updated means_of_id"
      assert campus_agent.nationality == "some updated nationality"
      assert campus_agent.phone == "some updated phone"
      assert campus_agent.residential_address == "some updated residential_address"
      assert campus_agent.secret_code == "some updated secret_code"
      assert campus_agent.state_of_origin == "some updated state_of_origin"
      assert campus_agent.status == "some updated status"
      assert campus_agent.verified == "some updated verified"
    end

    test "update_campus_agent/2 with invalid data returns error changeset" do
      campus_agent = campus_agent_fixture()

      assert {:error, %Ecto.Changeset{}} =
               AgentsAndSuppliers.update_campus_agent(campus_agent, @invalid_attrs)

      assert campus_agent == AgentsAndSuppliers.get_campus_agent!(campus_agent.id)
    end

    test "delete_campus_agent/1 deletes the campus_agent" do
      campus_agent = campus_agent_fixture()
      assert {:ok, %CampusAgent{}} = AgentsAndSuppliers.delete_campus_agent(campus_agent)

      assert_raise Ecto.NoResultsError, fn ->
        AgentsAndSuppliers.get_campus_agent!(campus_agent.id)
      end
    end

    test "change_campus_agent/1 returns a campus_agent changeset" do
      campus_agent = campus_agent_fixture()
      assert %Ecto.Changeset{} = AgentsAndSuppliers.change_campus_agent(campus_agent)
    end
  end
end
