defmodule LetorEcom.CatalogueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Catalogue` context.
  """
  import LetorEcom.CentresFixtures

  @doc """
  Generate a item_category.
  """

  def item_category_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, item_category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name#{Enum.random(1..100)}",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Catalogue.create_item_category()

    item_category
  end

  @doc """
  Generate a item_subcategory.
  """
  def item_subcategory_fixture(attrs \\ %{}) do
    item_category = item_category_fixture()

    {:ok, item_subcategory} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name#{Enum.random(1..100)}",
        item_category_id: item_category.id
      })
      |> LetorEcom.Catalogue.create_item_subcategory()

    item_subcategory
  end

  @doc """
  Generate a item.
  """

  @doc """
  Generate a sku.
  """
  def sku_fixture(attrs \\ %{}) do
    pickup_centre = pickup_centre_fixture()

    {:ok, sku} =
      attrs
      |> Enum.into(%{
        code: "some code",
        item_name: "some item_name",
        pickup_centre_id: pickup_centre.id
      })
      |> LetorEcom.Catalogue.create_sku()

    sku
  end
end
