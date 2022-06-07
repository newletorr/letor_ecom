defmodule LetorEcom.AgentsAndSuppliersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.AgentsAndSuppliers` context.
  """

  @doc """
  Generate a supplier.
  """
  def supplier_fixture(attrs \\ %{}) do
    {:ok, supplier} =
      attrs
      |> Enum.into(%{
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
      })
      |> LetorEcom.AgentsAndSuppliers.create_supplier()

    supplier
  end
end
