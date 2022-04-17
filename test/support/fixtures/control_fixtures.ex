defmodule LetorEcom.ControlFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Control` context.
  """

  @doc """
  Generate a ecommerce_control.
  """

  def ecommerce_control_fixture(attrs \\ %{}) do
    {:ok, ecommerce_control} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: "#{Enum.random(1..100)}some name",
        region: "some region"
      })
      |> LetorEcom.Control.create_ecommerce_control()

    ecommerce_control
  end

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        city: "some city",
        country: "some country",
        location_area: "some location_area",
        location_coordinates: "some location_coordinates",
        postal_code: "some postal_code",
        state: "some state"
      })
      |> LetorEcom.Control.create_location()

    location
  end

  @doc """
  Generate a covered_institution.
  """
  def covered_institution_fixture(attrs \\ %{}) do
    location = location_fixture()
    ecommerce_control = ecommerce_control_fixture

    {:ok, covered_institution} =
      attrs
      |> Enum.into(%{
        campus_name: "some campus_name#{Enum.random(10..100)}",
        name: "some name",
        location_id: location.id,
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.Control.create_covered_institution()

    covered_institution
  end
end
