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
    ecommerce_control = ecommerce_control_fixture()

    {:ok, pickup_centre} =
      attrs
      |> Enum.into(%{
        address: "some address",
        area: "some area",
        city: "some city",
        country: "some country",
        longitude_and_latitude_point: %Geo.Point{coordinates: {3.90010, 0.90000}, srid: 4326},
        name: "some name",
        state: "some state",
        ecommerce_control_id: ecommerce_control.id
      })
      |> LetorEcom.Centres.create_pickup_centre()

    pickup_centre
  end

  @doc """
  Generate a inventory_location.
  """
  def inventory_location_fixture(attrs \\ %{}) do
    {:ok, inventory_location} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: "some type"
      })
      |> LetorEcom.Centres.create_inventory_location()

    inventory_location
  end

  @doc """
  Generate a daily_deal.
  """
  def daily_deal_fixture(attrs \\ %{}) do
    {:ok, daily_deal} =
      attrs
      |> Enum.into(%{})
      |> LetorEcom.Centres.create_daily_deal()

    daily_deal
  end

  @doc """
  Generate a popular_item.
  """
  def popular_item_fixture(attrs \\ %{}) do
    {:ok, popular_item} =
      attrs
      |> Enum.into(%{})
      |> LetorEcom.Centres.create_popular_item()

    popular_item
  end

  @doc """
  Generate a featured_item.
  """
  def featured_item_fixture(attrs \\ %{}) do
    {:ok, featured_item} =
      attrs
      |> Enum.into(%{})
      |> LetorEcom.Centres.create_featured_item()

    featured_item
  end

  @doc """
  Generate a inventory.
  """
  def inventory_fixture(attrs \\ %{}) do
    {:ok, inventory} =
      attrs
      |> Enum.into(%{
        brand_name: "some brand_name",
        buy_price: "120.5",
        description: "some description",
        expired: true,
        expiry_date: ~D[2022-04-06],
        external_quantity: 42,
        external_quantity_uom: "some external_quantity_uom",
        intenal_quantity_uom: "some intenal_quantity_uom",
        internal_quantity: 42,
        max_external_quantity: 42,
        max_internal_quantity: 42,
        name: "some name",
        qr_code: "some qr_code",
        quality_assurance_status: "some quality_assurance_status",
        sales_price: "120.5",
        size: 42,
        status: "some status"
      })
      |> LetorEcom.Centres.create_inventory()

    inventory
  end

  @doc """
  Generate a inventory_change_history.
  """

  @doc """
  Generate a inventory_change_history.
  """
  def inventory_change_history_fixture(attrs \\ %{}) do
    {:ok, inventory_change_history} =
      attrs
      |> Enum.into(%{
        buy_price: "120.5",
        external_quantity: 42,
        internal_quantity: 42,
        sales_price: "120.5",
        change_type: "created"
      })
      |> LetorEcom.Centres.create_inventory_change_history()

    inventory_change_history
  end
end
