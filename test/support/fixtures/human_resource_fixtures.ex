defmodule LetorEcom.HumanResourceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.HumanResource` context.
  """

  @doc """
  Generate a staff.
  """
  def staff_fixture(attrs \\ %{}) do
    {:ok, staff} =
      attrs
      |> Enum.into(%{
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
      })
      |> LetorEcom.HumanResource.create_staff()

    staff
  end

  @doc """
  Generate a driver.
  """
  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        phone: "some phone",
        status: "some status"
      })
      |> LetorEcom.HumanResource.create_driver()

    driver
  end

  @doc """
  Generate a staff_posting.
  """
  def staff_posting_fixture(attrs \\ %{}) do
    {:ok, staff_posting} =
      attrs
      |> Enum.into(%{
        date_posted: ~D[2022-04-03],
        previous_posting: "some previous_posting"
      })
      |> LetorEcom.HumanResource.create_staff_posting()

    staff_posting
  end
end
