defmodule LetorEcom.Catalogue do
  @moduledoc """
  The Catalogue context.
  """

  import Ecto.Query, warn: false
  import Mogrify
  alias Ecto.Multi
  alias LetorEcom.Repo

  alias LetorEcom.Catalogue.{
    Item,
    ItemCategory,
    ItemImage,
    ItemSubcategory,
    ItemTag,
    ItemTagging,
    Sku
  }

  alias LetorEcom.Centres.{Inventory, InventoryChangeHistory}

  @doc """
  Returns the list of item_categories.

  ## Examples

      iex> list_item_categories()
      [%ItemCategory{}, ...]

  """
  def list_item_categories do
    Repo.all(ItemCategory)
  end

  @doc """
  Gets a single item_category.

  Raises `Ecto.NoResultsError` if the Item category does not exist.

  ## Examples

      iex> get_item_category!(123)
      %ItemCategory{}

      iex> get_item_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_category!(id), do: Repo.get!(ItemCategory, id)

  @doc """
  Creates a item_category.

  ## Examples

      iex> create_item_category(%{field: value})
      {:ok, %ItemCategory{}}

      iex> create_item_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_category(attrs \\ %{}) do
    %ItemCategory{}
    |> ItemCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_category.

  ## Examples

      iex> update_item_category(item_category, %{field: new_value})
      {:ok, %ItemCategory{}}

      iex> update_item_category(item_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_category(%ItemCategory{} = item_category, attrs) do
    item_category
    |> ItemCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_category.

  ## Examples

      iex> delete_item_category(item_category)
      {:ok, %ItemCategory{}}

      iex> delete_item_category(item_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_category(%ItemCategory{} = item_category) do
    Repo.delete(item_category)
  end

  @doc """
  Returns the list of item_subcategories.

  ## Examples

      iex> list_item_subcategories()
      [%ItemSubcategory{}, ...]

  """
  def list_item_subcategories do
    Repo.all(ItemSubcategory)
  end

  @doc """
  Gets a single item_subcategory.

  Raises `Ecto.NoResultsError` if the Item subcategory does not exist.

  ## Examples

      iex> get_item_subcategory!(123)
      %ItemSubcategory{}

      iex> get_item_subcategory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_subcategory!(id), do: Repo.get!(ItemSubcategory, id)

  @doc """
  Creates a item_subcategory.

  ## Examples

      iex> create_item_subcategory(%{field: value})
      {:ok, %ItemSubcategory{}}

      iex> create_item_subcategory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_subcategory(attrs \\ %{}) do
    %ItemSubcategory{}
    |> ItemSubcategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_subcategory.

  ## Examples

      iex> update_item_subcategory(item_subcategory, %{field: new_value})
      {:ok, %ItemSubcategory{}}

      iex> update_item_subcategory(item_subcategory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_subcategory(%ItemSubcategory{} = item_subcategory, attrs) do
    item_subcategory
    |> ItemSubcategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_subcategory.

  ## Examples

      iex> delete_item_subcategory(item_subcategory)
      {:ok, %ItemSubcategory{}}

      iex> delete_item_subcategory(item_subcategory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_subcategory(%ItemSubcategory{} = item_subcategory) do
    Repo.delete(item_subcategory)
  end

  @doc """
  Returns the list of sku.

  ## Examples

      iex> list_sku()
      [%Sku{}, ...]

  """
  def list_sku do
    Repo.all(Sku)
  end

  @doc """
  Gets a single sku.

  Raises `Ecto.NoResultsError` if the Sku does not exist.

  ## Examples

      iex> get_sku!(123)
      %Sku{}

      iex> get_sku!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sku!(id), do: Repo.get!(Sku, id)

  @doc """
  Creates a sku.

  ## Examples

      iex> create_sku(%{field: value})
      {:ok, %Sku{}}

      iex> create_sku(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sku(attrs \\ %{}) do
    %Sku{}
    |> Sku.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sku.

  ## Examples

      iex> update_sku(sku, %{field: new_value})
      {:ok, %Sku{}}

      iex> update_sku(sku, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sku(%Sku{} = sku, attrs) do
    sku
    |> Sku.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sku.

  ## Examples

      iex> delete_sku(sku)
      {:ok, %Sku{}}

      iex> delete_sku(sku)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sku(%Sku{} = sku) do
    Repo.delete(sku)
  end

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  def create_sku_inventory_and_item(attrs \\ %{}) do
    sku_changeset =
      %Sku{} |> Sku.changeset(%{item_name: attrs.name, pickup_centre_id: attrs.pickup_centre_id})

    Multi.new()
    |> Multi.insert(:sku, sku_changeset)
    |> Multi.run(:item, fn repo, %{sku: sku} ->
      item_changeset =
        %Item{}
        |> Item.changeset(%{
          item_subcategory_id: attrs.item_subcategory_id,
          barcode: attrs.barcode,
          item_image_id: attrs.item_image_id,
          type: attrs.type,
          name: attrs.name,
          main_price: attrs.main_price,
          package_size: attrs.package_size,
          description: attrs.description,
          sku_id: sku.id
        })

      repo.insert(item_changeset)
    end)
    |> Multi.run(:item_tagging, fn repo, %{item: item} ->
      if is_nil(item.id) == false do
        {:ok, nil}
      else
        item_tagging_changeset =
          %ItemTagging{}
          |> ItemTagging.changeset(%{item_tag_id: attrs.item_tag_id, item_id: item.id})

        repo.insert(item_tagging_changeset)
      end
    end)
    |> Multi.run(:item_qr_code, fn repo, %{item: item} ->
      {:ok, qr_code} =
        item.id
        |> QRCode.create()
        |> Result.and_then(&QRCode.Svg.save_as(&1, "/tmp/#{item.name}.svg"))

      item_qr_code =
        qr_code
        |> Mogrify.open()
        |> format("png")
        |> save(path: "/tmp/#{item.name}.png")

      qr_code_changeset = item |> Item.qr_code_changeset(%{qr_code: item_qr_code.path})

      repo.update(qr_code_changeset)
    end)
    |> Multi.run(:inventory, fn repo, %{sku: sku} ->
      inventory_changeset =
        %Inventory{}
        |> Inventory.changeset(%{
          buy_price: attrs.buy_price,
          max_external_quantity: attrs.max_external_quantity,
          max_internal_quantity: attrs.max_internal_quantity,
          sales_price: attrs.sales_price,
          expiry_date: attrs.expiry_date,
          item_image_id: attrs.item_image_id,
          pickup_centre_id: attrs.pickup_centre_id,
          inventory_location_id: attrs.inventory_location_id,
          description: attrs.description,
          internal_quantity: attrs.internal_quantity,
          external_quantity: attrs.external_quantity,
          name: attrs.name,
          internal_quantity_uom: attrs.internal_quantity_uom,
          external_quantity_uom: attrs.external_quantity_uom,
          sku_id: sku.id
        })

      repo.insert(inventory_changeset)
    end)
    |> Multi.run(:inventory_qr_code, fn repo, %{inventory: inventory} ->
      {:ok, qr_code} =
        inventory.id
        |> QRCode.create()
        |> Result.and_then(&QRCode.Svg.save_as(&1, "/tmp/#{inventory.name}.svg"))

      inventory_qr_code =
        qr_code
        |> Mogrify.open()
        |> format("png")
        |> save(path: "/tmp/#{inventory.name}.png")

      qr_code_changeset =
        inventory
        |> Inventory.qr_code_changeset(%{qr_code: inventory_qr_code.path})

      repo.update(qr_code_changeset)
    end)
    |> Multi.run(:inventory_change_history, fn repo, %{inventory: inventory} ->
      inventory_history_changeset =
        %InventoryChangeHistory{}
        |> InventoryChangeHistory.changeset(%{
          buy_price: inventory.buy_price,
          external_quantity: inventory.external_quantity,
          internal_quantity: inventory.internal_quantity,
          sales_price: inventory.sales_price,
          inventory_id: inventory.id,
          change_type: "created"
        })

      repo.insert(inventory_history_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates items for special category.

  ## Examples

      iex> update_for_special_cat(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_for_special_cat(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_for_special_cat(%Item{} = item, attrs) do
    item
    |> Item.special_category_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns the list of item_images.

  ## Examples

      iex> list_item_images()
      [%ItemImage{}, ...]

  """
  def list_item_images do
    Repo.all(ItemImage)
  end

  @doc """
  Gets a single item_image.

  Raises `Ecto.NoResultsError` if the Item image does not exist.

  ## Examples

      iex> get_item_image!(123)
      %ItemImage{}

      iex> get_item_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_image!(id), do: Repo.get!(ItemImage, id)

  @doc """
  Creates a item_image.

  ## Examples

      iex> create_item_image(%{field: value})
      {:ok, %ItemImage{}}

      iex> create_item_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_image(attrs \\ %{}) do
    %ItemImage{}
    |> ItemImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_image.

  ## Examples

      iex> update_item_image(item_image, %{field: new_value})
      {:ok, %ItemImage{}}

      iex> update_item_image(item_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_image(%ItemImage{} = item_image, attrs) do
    item_image
    |> ItemImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_image.

  ## Examples

      iex> delete_item_image(item_image)
      {:ok, %ItemImage{}}

      iex> delete_item_image(item_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_image(%ItemImage{} = item_image) do
    Repo.delete(item_image)
  end

  @doc """
  Returns the list of item_tag.

  ## Examples

      iex> list_item_tag()
      [%ItemTag{}, ...]

  """
  def list_item_tag do
    Repo.all(ItemTag)
  end

  @doc """
  Gets a single item_tag.

  Raises `Ecto.NoResultsError` if the Item tag does not exist.

  ## Examples

      iex> get_item_tag!(123)
      %ItemTag{}

      iex> get_item_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_tag!(id), do: Repo.get!(ItemTag, id)

  @doc """
  Creates a item_tag.

  ## Examples

      iex> create_item_tag(%{field: value})
      {:ok, %ItemTag{}}

      iex> create_item_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_tag(attrs \\ %{}) do
    %ItemTag{}
    |> ItemTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_tag.

  ## Examples

      iex> update_item_tag(item_tag, %{field: new_value})
      {:ok, %ItemTag{}}

      iex> update_item_tag(item_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_tag(%ItemTag{} = item_tag, attrs) do
    item_tag
    |> ItemTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_tag.

  ## Examples

      iex> delete_item_tag(item_tag)
      {:ok, %ItemTag{}}

      iex> delete_item_tag(item_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_tag(%ItemTag{} = item_tag) do
    Repo.delete(item_tag)
  end

  @doc """
  Returns the list of item_taggings.

  ## Examples

      iex> list_item_taggings()
      [%ItemTagging{}, ...]

  """
  def list_item_taggings do
    Repo.all(ItemTagging)
  end

  @doc """
  Gets a single item_tagging.

  Raises `Ecto.NoResultsError` if the Item tagging does not exist.

  ## Examples

      iex> get_item_tagging!(123)
      %ItemTagging{}

      iex> get_item_tagging!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_tagging!(id), do: Repo.get!(ItemTagging, id)

  @doc """
  Creates a item_tagging.

  ## Examples

      iex> create_item_tagging(%{field: value})
      {:ok, %ItemTagging{}}

      iex> create_item_tagging(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_tagging(attrs \\ %{}) do
    %ItemTagging{}
    |> ItemTagging.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_tagging.

  ## Examples

      iex> update_item_tagging(item_tagging, %{field: new_value})
      {:ok, %ItemTagging{}}

      iex> update_item_tagging(item_tagging, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_tagging(%ItemTagging{} = item_tagging, attrs) do
    item_tagging
    |> ItemTagging.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_tagging.

  ## Examples

      iex> delete_item_tagging(item_tagging)
      {:ok, %ItemTagging{}}

      iex> delete_item_tagging(item_tagging)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_tagging(%ItemTagging{} = item_tagging) do
    Repo.delete(item_tagging)
  end
end
