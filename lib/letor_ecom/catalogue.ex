defmodule LetorEcom.Catalogue do
  @moduledoc """
  The Catalogue context.
  """

  import Ecto.Query, warn: false
  import Mogrify
  alias Ecto.Multi
  alias LetorEcom.{Centres, Repo}

  alias LetorEcom.Catalogue.{
    Item,
    ItemCategory,
    ItemImage,
    ItemSubcategory,
    ItemTag,
    ItemTagging,
    Sku
  }

  alias LetorEcom.Centres.{DailyDeal, FeaturedItem, Inventory, InventoryChangeHistory}

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(FeaturedItem, %{scope: :pickup_centre, limit: limit, offset: offset}) do
    FeaturedItem
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  def query(DailyDeals, %{scope: :pickup_centre, limit: limit, offset: offset}) do
    DailyDeals
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  def query(PopularItem, %{scope: :pickup_centre, limit: limit, offset: offset}) do
    PopularItem
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  def query(ViewItem, %{scope: :user, limit: limit, offset: offset}) do
    ViewItem
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  def query(Item, args) do
    args
    |> query_items
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

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

  @doc """
  Return an item by name
  """
  def item_by_name(name) do
    Repo.one(from item in Item, where: item.name == ^name)
  end

  @doc """
  Return an item by barcode
  """
  def item_by_barcode(barcode) do
    Repo.one(from item in Item, where: item.barcode == ^barcode)
  end

  @doc """
  Returns the list of all items, with searching by keywords, pagination, filtering and ordering possible.

  ## Examples

      iex> list_all_items()
      [%Item{}, ...]

  """
  def list_all_items(args) do
    args
    |> query_items
    |> Repo.all()
  end

  @spec list_groceries_items(any) :: any
  @doc """
  Returns the list of all Groceries and house hold items, with searching by keywords, pagination, filtering and ordering possible.

  ## Examples

      iex> list_groceries_items()
      [%Item{}, ...]
  """
  def list_groceries_items(args) do
    args
    |> query_groceries_items
    |> Repo.all()
  end

  @spec query_groceries_items(any) :: any
  def query_groceries_items(args) do
    item_query =
      from i in Item,
        where: i.type == "Groceries" and i.out_of_stock == false and i.expired == false

    args
    |> Enum.reduce(item_query, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(q in query,
          join: it in assoc(q, :item_tag),
          join: r in assoc(q, :recipes),
          join: i in assoc(q, :item_subcategory),
          join: c in assoc(i, :item_category),
          where:
            ilike(q.name, ^pattern) or ilike(q.barcode, ^pattern) or ilike(i.name, ^pattern) or
              ilike(c.name, ^pattern) or
              ilike(q.description, ^pattern) or ilike(it.name, ^pattern) or
              ilike(r.name, ^pattern)
        )

      {:filters, filters}, query ->
        filters_with(filters, query)

      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(q in query, order_by: [{^order, :actual_price}])
    end)
  end

  @spec list_health_items(any) :: any
  @doc """
  Returns the list of all Drugs and medical consumables items, with searching by keywords, pagination, filtering and ordering possible.

  ## Examples

      iex> list_health_items()
      [%Item{}, ...]
  """
  def list_health_items(args) do
    args
    |> query_health_items
    |> Repo.all()
  end

  @spec query_health_items(any) :: any
  def query_health_items(args) do
    item_query =
      from i in Item, where: i.type == "Health" and i.out_of_stock == false and i.expired == false

    args
    |> Enum.reduce(item_query, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(q in query,
          join: it in assoc(q, :item_tag),
          join: r in assoc(q, :recipe),
          join: i in assoc(q, :item_subcategory),
          join: c in assoc(i, :item_category),
          where:
            ilike(q.name, ^pattern) or ilike(q.barcode, ^pattern) or ilike(i.name, ^pattern) or
              ilike(c.name, ^pattern) or
              ilike(q.description, ^pattern) or ilike(it.name, ^pattern) or
              ilike(r.name, ^pattern)
        )

      {:filters, filters}, query ->
        filters_with(filters, query)

      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(q in query, order_by: [{^order, :actual_price}])
    end)
  end

  @spec list_household_items(any) :: any
  @doc """
  Returns the list of all Drugs and medical consumables items, with searching by keywords, pagination, filtering and ordering possible.

  ## Examples

      iex> list_items()
      [%Item{}, ...]
  """
  def list_household_items(args) do
    args
    |> query_household_items
    |> Repo.all()
  end

  def query_household_items(args) do
    item_query =
      from i in Item,
        where:
          i.type == "Household and Personal Care" and i.out_of_stock == false and
            i.expired == false

    args
    |> Enum.reduce(item_query, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(q in query,
          join: it in assoc(q, :item_tag),
          join: r in assoc(q, :recipe),
          join: i in assoc(q, :item_subcategory),
          join: c in assoc(i, :item_category),
          where:
            ilike(q.name, ^pattern) or ilike(q.barcode, ^pattern) or ilike(i.name, ^pattern) or
              ilike(c.name, ^pattern) or
              ilike(q.description, ^pattern) or ilike(it.name, ^pattern) or
              ilike(r.name, ^pattern)
        )

      {:filters, filters}, query ->
        filters_with(filters, query)

      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(q in query, order_by: [{^order, :actual_price}])
    end)
  end

  def query_items(args) do
    item_query = from i in Item, where: i.out_of_stock == false and i.expired == false

    args
    |> Enum.reduce(item_query, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(q in query,
          join: i in assoc(q, :item_subcategory),
          join: c in assoc(i, :item_category),
          where:
            ilike(q.name, ^pattern) or ilike(q.barcode, ^pattern) or ilike(i.name, ^pattern) or
              ilike(c.name, ^pattern) or
              ilike(q.description, ^pattern)
        )

      {:filters, filters}, query ->
        filters_with(filters, query)

      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(q in query, order_by: [{^order, :actual_price}])
    end)
  end

  defp filters_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:tag, tag_names}, query ->
        from q in query,
          join: i in assoc(q, :item_tag),
          where: i.name in ^tag_names

      {:brand_name, brand_names}, query ->
        from q in query,
          where: q.brand_name in ^brand_names
    end)
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
        if attrs[:bulk] == true do
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
  Add items to list of featured items.

  ## Examples

      iex> add_item_to_featured(item, pickup_centre_id)
      {:ok, %FeaturedItem{}}
  """
  def add_item_to_featured(item, attrs \\ %{}) do
    existing_featured_item =
      Repo.one(
        from featured_item in FeaturedItem,
          join: pickup_centre in assoc(featured_item, :pickup_centre),
          where: pickup_centre.id == ^attrs.pickup_centre_id
      )

    case existing_featured_item do
      nil ->
        {:ok, featured_item} = Centres.create_featured_item(attrs)

        {:ok, item} = update_for_special_cat(item, %{featured_item_id: featured_item.id})

        {:ok, item}

      _ ->
        {:ok, item} = update_for_special_cat(item, %{featured_item_id: existing_featured_item.id})

        {:ok, item}
    end
  end

  @doc """
  Add items to list of featured items.

  ## Examples

      iex> add_item_to_featured(item, pickup_centre_id)
      {:ok, %FeaturedItem{}}
  """
  def add_item_to_daily_deals(item, attrs \\ %{}) do
    existing_daily_deal =
      Repo.one(
        from daily_deal in DailyDeal,
          join: pickup_centre in assoc(daily_deal, :pickup_centre),
          where: pickup_centre.id == ^attrs.pickup_centre_id
      )

    case existing_daily_deal do
      nil ->
        {:ok, daily_deal} = Centres.create_featured_item(attrs)

        {:ok, item} = update_for_special_cat(item, %{daily_deal_id: daily_deal.id})

        {:ok, item}

      _ ->
        {:ok, item} = update_for_special_cat(item, %{featured_item_id: existing_daily_deal.id})

        {:ok, item}
    end
  end

  def remove_item_from_featured(item) do
    item
    |> Item.special_category_changeset(%{featured_item_id: nil})
    |> Repo.update()
  end

  def remove_item_from_daily_deals(item) do
    item
    |> Item.special_category_changeset(%{daily_deal_id: nil})
    |> Repo.update()
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
    # item_image_changeset = %ItemImage{} |> ItemImage.changeset(attrs)

    %ItemImage{}
    |> ItemImage.changeset(attrs)
    |> Repo.insert()

    # Multi.new()
    # |> Multi.insert(:item_image, item_image_changeset)
    # |> Multi.run(:image_uploads, fn repo, %{item_image: item_image} ->
    # uploads_changeset =
    #  item_image
    # |> ItemImage.image_uploads_changeset(attrs)

    # repo.update(uploads_changeset)
    # end)
    # |> Repo.transaction()
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

  def get_item_image1(item_image) do
    case is_nil(item_image.item_image1) == false do
      true ->
        image_url =
          LetorEcom.Uploads.url({item_image.item_image1.file_name, item_image}, :thumb,
            signed: true
          )

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
  end

  def get_item_image2(item_image) do
    case is_nil(item_image.item_image1) == false do
      true ->
        image_url =
          LetorEcom.Uploads.url({item_image.item_image2.file_name, item_image}, :thumb,
            signed: true
          )

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
  end

  def get_item_image3(item_image) do
    case is_nil(item_image.item_image1) == false do
      true ->
        image_url =
          LetorEcom.Uploads.url({item_image.item_image3.file_name, item_image}, :thumb,
            signed: true
          )

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
  end

  def get_item_image4(item_image) do
    case is_nil(item_image.item_image1) == false do
      true ->
        image_url =
          LetorEcom.Uploads.url({item_image.item_image4.file_name, item_image}, :thumb,
            signed: true
          )

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
  end

  def get_item_qr_code_url(item) do
    case is_nil(item.qr_code) == false do
      true ->
        image_url = LetorEcom.Uploads.url({item.qr_code.file_name, item}, :thumb, signed: true)

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
  end

  def get_inventory_qr_code_url(inventory) do
    case is_nil(inventory.qr_code) == false do
      true ->
        image_url =
          LetorEcom.Uploads.url({inventory.qr_code.file_name, inventory}, :thumb, signed: true)

        {:ok, image_url}

      _ ->
        {:ok, nil}
    end
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
