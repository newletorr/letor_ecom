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

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        actual_price: "120.5",
        availability_time: "some availability_time",
        available_quantity: 42,
        barcode: "some barcode",
        brand_name: "some brand_name",
        bulk: true,
        customization_allowed: true,
        description: "some description",
        details: "some details",
        expired: true,
        group_buying_price: "120.5",
        item_code: "some item_code",
        main_price: "120.5",
        name: "some name",
        out_of_stock: true,
        package_size: "some package_size",
        preparation_time: "some preparation_time",
        promo_price: "120.5",
        qa_cleared: true,
        qr_code: "some qr_code",
        regional_name: "some regional_name",
        size: 42,
        third_party_item: "some third_party_item",
        type: "some type"
      })
      |> LetorEcom.Catalogue.create_item()

    item
  end

  @doc """
  Generate a item_image.
  """
  def item_image_fixture(attrs \\ %{}) do
    {:ok, item_image} =
      attrs
      |> Enum.into(%{
        item_image1: "some item_image1",
        item_image2: "some item_image2",
        item_image3: "some item_image3",
        item_image4: "some item_image4",
        item_name: "some item_name",
        video_url: "some video_url"
      })
      |> LetorEcom.Catalogue.create_item_image()

    item_image
  end

  @doc """
  Generate a item_tag.
  """
  def item_tag_fixture(attrs \\ %{}) do
    {:ok, item_tag} =
      attrs
      |> Enum.into(%{
        class: "some class",
        description: "some description",
        name: "some name"
      })
      |> LetorEcom.Catalogue.create_item_tag()

    item_tag
  end

  @doc """
  Generate a item_tagging.
  """
  def item_tagging_fixture(attrs \\ %{}) do
    {:ok, item_tagging} =
      attrs
      |> Enum.into(%{})
      |> LetorEcom.Catalogue.create_item_tagging()

    item_tagging
  end
end
