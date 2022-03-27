defmodule LetorEcom.ControlFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Control` context.
  """

  @doc """
  Generate a centre_code.
  """
  def centre_code_fixture(attrs \\ %{}) do
    {:ok, centre_code} =
      attrs
      |> Enum.into(%{
        centre_name: "#{Enum.random(1..100)}Centre Name"
      })
      |> LetorEcom.Control.create_centre_code()

    centre_code
  end

  @doc """
  Generate a ecommerce_control.
  """
  def ecommerce_control_fixture(attrs \\ %{}) do
    centre_code = centre_code_fixture()

    {:ok, ecommerce_control} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: "#{Enum.random(1..100)}some name",
        region: "some region",
        centre_code_id: centre_code.id
      })
      |> LetorEcom.Control.create_ecommerce_control()

    ecommerce_control
  end
end
