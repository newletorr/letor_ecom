defmodule LetorEcom.CentresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Centres` context.
  """
  import LetorEcom.ControlFixtures

  @doc """
  Generate a pickup_centre.
  """
  def pickup_centre_fixture(attrs \\ %{}) do
    centre_code = centre_code_fixture()
    ecommerce_control = ecommerce_control_fixture()

    {:ok, pickup_centre} =
      attrs
      |> Enum.into(%{
        address: "some address",
        area: "some area",
        city: "some city",
        country: "some country",
        location_coordinates: "some location_coordinates",
        name: "some name",
        state: "some state",
        centre_code_id: centre_code.id,
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.Centres.create_pickup_centre()

    pickup_centre
  end
end
