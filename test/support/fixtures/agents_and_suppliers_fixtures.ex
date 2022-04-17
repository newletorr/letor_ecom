defmodule LetorEcom.AgentsAndSuppliersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.AgentsAndSuppliers` context.
  """

  @doc """
  Generate a campus_agent.
  """
  def campus_agent_fixture(attrs \\ %{}) do
    {:ok, campus_agent} =
      attrs
      |> Enum.into(%{
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
      })
      |> LetorEcom.AgentsAndSuppliers.create_campus_agent()

    campus_agent
  end
end
