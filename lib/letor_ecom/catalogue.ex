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
    |> ItemCategory.update_changeset(attrs)
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
    |> ItemSubcategory.update_changeset(attrs)
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
    |> Sku.update_changeset(attrs)
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

  @spec create_sku_inventory_and_item(
          atom
          | %{:name => any, :pickup_centre_id => any, optional(any) => any}
        ) :: any
  def create_sku_inventory_and_item(attrs \\ %{}) do
    sku_changeset = %Sku{} |> Sku.changeset(attrs)

    Multi.new()
    # insert items stock keeping unit
    |> Multi.insert(:sku, sku_changeset)
    # Create an inventory item for the item created above
    |> Multi.run(:inventory, fn repo, %{sku: sku} ->
      inventory_changeset =
        %Inventory{}
        |> Inventory.changeset(Map.put(attrs, :sku_id, sku.id))

      repo.insert(inventory_changeset)
    end)
    # Create qr code for inventory item
    |> Multi.run(:inventory_qr_code, fn repo, %{inventory: inventory} ->
      {:ok, qr_code} =
        inventory.inventory_code
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
    # Track inventory creation history
    |> Multi.run(:inventory_change_history, fn repo, %{inventory: inventory} ->
      inventory_history_changeset =
        %InventoryChangeHistory{}
        |> InventoryChangeHistory.changeset(%{
          buy_price: inventory.buy_price,
          bulk_quantity: inventory.bulk_quantity,
          sales_unit_quantity: inventory.sales_unit_quantity,
          unit_sales_price: inventory.unit_sales_price,
          bulk_sales_price: inventory.bulk_sales_price,
          inventory_id: inventory.id,
          change_type: "created"
        })

      repo.insert(inventory_history_changeset)
    end)
    # Create an item with the stock keeping unit above
    |> Multi.run(:item, fn repo, %{sku: sku, inventory: inventory} ->
      unit_price = inventory.unit_sales_price
      bulk_price = inventory.bulk_sales_price

      item_changeset =
        if is_nil(attrs[:bulk]) == false do
          bulk_sku_and_price = %{sku_id: sku.id, main_price: bulk_price}
          %Item{} |> Item.changeset(Map.merge(attrs, bulk_sku_and_price))
        else
          unit_sku_and_price = %{sku_id: sku.id, main_price: unit_price}
          %Item{} |> Item.changeset(Map.merge(attrs, unit_sku_and_price))
        end

      repo.insert(item_changeset)
    end)
    # Create item tagging for item if a tag_id is provided
    |> Multi.run(:item_tagging, fn repo, %{item: item} ->
      if is_nil(attrs.item_tag_id) == true do
        {:ok, nil}
      else
        item_tagging_changeset =
          %ItemTagging{}
          |> ItemTagging.changeset(%{item_tag_id: attrs.item_tag_id, item_id: item.id})

        repo.insert(item_tagging_changeset)
      end
    end)
    # create qr code for item
    |> Multi.run(:item_qr_code, fn repo, %{item: item} ->
      {:ok, qr_code} =
        item.item_code
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
    |> Item.update_changeset(attrs)
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
    # item
    # |> Item.deletion_changeset()
    Repo.delete(item)
  end

  @doc """
  Creates a item_image.

  ## Examples

      iex> create_item_image(%{field: value})
      {:ok, %ItemImage{}}

      iex> create_item_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_image(attrs \\ %{}) do
    item_image_changeset = %ItemImage{} |> ItemImage.changeset(attrs)

    Multi.new()
    |> Multi.insert(:item_image, item_image_changeset)
    |> Multi.run(:image_uploads, fn repo, %{item_image: item_image} ->
      uploads_changeset =
        item_image
        |> ItemImage.image_uploads_changeset(%{
          item_image1: attrs.item_image1,
          item_image2: attrs.item_image2,
          item_image3: attrs.item_image3,
          item_image4: attrs.item_image4
        })

      repo.update(uploads_changeset)
    end)
    |> Repo.transaction()
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
    |> ItemImage.update_changeset(attrs)
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
    |> ItemTag.update_changeset(attrs)
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
    item_tagging
    |> ItemTagging.deletion_changeset()
    |> Repo.delete()
  end
end
