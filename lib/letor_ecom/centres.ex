defmodule LetorEcom.Centres do
  @moduledoc """
  The Centres context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias LetorEcom.Repo
  alias LetorEcom.Account.User
  # alias LetorEcom.Catalogue.{Item, Sku}

  alias LetorEcom.Centres.{
    DailyDeal,
    FeaturedItem,
    PickupCentre,
    PopularItem,
    Purchase,
    PurchaseItem,
    Inventory,
    InventoryChangeHistory,
    InventoryLocation,
    InventoryMetric,
    QualityAssuranceRequirement
  }

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Inventory, args) do
    inventory_query(args)
  end

  def query(Purchase, %{scope: :pickup_centre, limit: limit, offset: offset}) do
    todays_date = Timex.today()
    purchase = from purchase in Purchase, where: type(purchase.inserted_at, :date) == ^todays_date

    purchase
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  def get_users_pickup_centre(staff_user) do
    pickup_centre =
      Repo.one(
        from(user in User,
          join: staff in assoc(user, :staff),
          join: staff_postings in assoc(staff, :staff_postings),
          join: pickup_centre in assoc(staff_postings, :pickup_centres),
          where: user.id == ^staff_user.id
        )
      )

    pickup_centre
  end

  @doc """
  Creates a pickup_centre.

  ## Examples

      iex> create_pickup_centre(%{field: value})
      {:ok, %PickupCentre{}}

      iex> create_pickup_centre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pickup_centre(attrs \\ %{}) do
    %PickupCentre{}
    |> PickupCentre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pickup_centre.

  ## Examples

      iex> update_pickup_centre(pickup_centre, %{field: new_value})
      {:ok, %PickupCentre{}}

      iex> update_pickup_centre(pickup_centre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pickup_centre(%PickupCentre{} = pickup_centre, attrs) do
    pickup_centre
    |> PickupCentre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pickup_centre.

  ## Examples

      iex> delete_pickup_centre(pickup_centre)
      {:ok, %PickupCentre{}}

      iex> delete_pickup_centre(pickup_centre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pickup_centre(%PickupCentre{} = pickup_centre) do
    Repo.delete(pickup_centre)
  end

  @doc """
  Creates a inventory_location.

  ## Examples

      iex> create_inventory_location(%{field: value})
      {:ok, %InventoryLocation{}}

      iex> create_inventory_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory_location(attrs \\ %{}) do
    %InventoryLocation{}
    |> InventoryLocation.changeset(attrs)
    |> Repo.insert()
  end

  def get_inventory_location!(id), do: Repo.get!(InventoryLocation, id)

  @doc """
  Updates a inventory_location.

  ## Examples

      iex> update_inventory_location(inventory_location, %{field: new_value})
      {:ok, %InventoryLocation{}}

      iex> update_inventory_location(inventory_location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory_location(%InventoryLocation{} = inventory_location, attrs) do
    inventory_location
    |> InventoryLocation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory_location.

  ## Examples

      iex> delete_inventory_location(inventory_location)
      {:ok, %InventoryLocation{}}

      iex> delete_inventory_location(inventory_location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory_location(%InventoryLocation{} = inventory_location) do
    Repo.delete(inventory_location)
  end

  @doc """
  Creates a daily_deal.

  ## Examples

      iex> create_daily_deal(%{field: value})
      {:ok, %DailyDeal{}}

      iex> create_daily_deal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_deal(attrs \\ %{}) do
    %DailyDeal{}
    |> DailyDeal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a daily_deal.

  ## Examples

      iex> update_daily_deal(daily_deal, %{field: new_value})
      {:ok, %DailyDeal{}}

      iex> update_daily_deal(daily_deal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_deal(%DailyDeal{} = daily_deal, attrs) do
    daily_deal
    |> DailyDeal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a daily_deal.

  ## Examples

      iex> delete_daily_deal(daily_deal)
      {:ok, %DailyDeal{}}

      iex> delete_daily_deal(daily_deal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_deal(%DailyDeal{} = daily_deal) do
    Repo.delete(daily_deal)
  end

  @doc """
  Creates a popular_item.

  ## Examples

      iex> create_popular_item(%{field: value})
      {:ok, %PopularItem{}}

      iex> create_popular_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_popular_item(attrs \\ %{}) do
    %PopularItem{}
    |> PopularItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a popular_item.

  ## Examples

      iex> update_popular_item(popular_item, %{field: new_value})
      {:ok, %PopularItem{}}

      iex> update_popular_item(popular_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_popular_item(%PopularItem{} = popular_item, attrs) do
    popular_item
    |> PopularItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a popular_item.

  ## Examples

      iex> delete_popular_item(popular_item)
      {:ok, %PopularItem{}}

      iex> delete_popular_item(popular_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_popular_item(%PopularItem{} = popular_item) do
    Repo.delete(popular_item)
  end

  @doc """
  Creates a featured_item.

  ## Examples

      iex> create_featured_item(%{field: value})
      {:ok, %FeaturedItem{}}

      iex> create_featured_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_featured_item(attrs \\ %{}) do
    %FeaturedItem{}
    |> FeaturedItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a featured_item.

  ## Examples

      iex> update_featured_item(featured_item, %{field: new_value})
      {:ok, %FeaturedItem{}}

      iex> update_featured_item(featured_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_featured_item(%FeaturedItem{} = featured_item, attrs) do
    featured_item
    |> FeaturedItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a featured_item.

  ## Examples

      iex> delete_featured_item(featured_item)
      {:ok, %FeaturedItem{}}

      iex> delete_featured_item(featured_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_featured_item(%FeaturedItem{} = featured_item) do
    Repo.delete(featured_item)
  end

  # def check_inventory_lead_time(inventory_id) do
  #
  # from inventory in Inventory, join: purchase_item in assoc(inventory, :purchase_items), join: purchase in assoc(purchase_item, :purchase),

  # end

  def search_inventories(query, nil), do: query

  def search_inventories(query, keywords) do
    pattern = "%#{keywords}%"

    from(
      inventory in query,
      where: ilike(inventory.name, ^pattern)
    )
  end

  def list_inventory(args) do
    args
    |> inventory_query
    |> Repo.all()
  end

  def inventory_query(args) do
    args
    |> Enum.reduce(Inventory, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(inventory in query,
          join: sku in assoc(inventory, :sku),
          join: purchase_item in assoc(inventory, :purchase_items),
          join: inventory_location in assoc(inventory, :inventory_location),
          join: item_subcategory in assoc(inventory, :item_subcategory),
          join: item_category in assoc(item_subcategory, :item_category),
          where:
            ilike(inventory.name, ^pattern) or
              ilike(inventory.description, ^pattern) or ilike(sku.item_name, ^pattern) or
              ilike(sku.code, ^pattern) or ilike(inventory_location.name, ^pattern) or
              ilike(inventory_location.type, ^pattern) or ilike(item_subcategory.name, ^pattern) or
              ilike(item_category.name, ^pattern) or ilike(purchase_item.suppliers_name, ^pattern) or
              ilike(purchase_item.suppliers_phone, ^pattern) or
              ilike(purchase_item.suppliers_email, ^pattern)
        )

      {:filters, filters}, query ->
        filters_with(filters, query)

      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(q in query, order_by: [{^order, :inserted_at}])
    end)
  end

  defp filters_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:bulk_quantity, value}, query ->
        from(q in query, where: q.bulk_quantity == ^value)

      {:sales_unit_quantity, value}, query ->
        from(q in query, where: q.sales_unit_quantity == ^value)

      {:status, value}, query ->
        from(q in query, where: q.status == ^value)

      {:brand_name, brand_names}, query ->
        from(q in query,
          where: q.brand_name in ^brand_names
        )
    end)
  end

  @doc """
  Creates a inventory.

  ## Examples

      iex> create_inventory(%{field: value})
      {:ok, %Inventory{}}

      iex> create_inventory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventory.

  ## Examples

      iex> update_inventory(inventory, %{field: new_value})
      {:ok, %Inventory{}}

      iex> update_inventory(inventory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory.

  ## Examples

      iex> delete_inventory(inventory)
      {:ok, %Inventory{}}

      iex> delete_inventory(inventory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  @doc """
  Creates a inventory_change_history.

  ## Examples

      iex> create_inventory_change_history(%{field: value})
      {:ok, %InventoryChangeHistory{}}

      iex> create_inventory_change_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory_change_history(attrs \\ %{}) do
    %InventoryChangeHistory{}
    |> InventoryChangeHistory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventory_change_history.

  ## Examples

      iex> update_inventory_change_history(inventory_change_history, %{field: new_value})
      {:ok, %InventoryChangeHistory{}}

      iex> update_inventory_change_history(inventory_change_history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory_change_history(%InventoryChangeHistory{} = inventory_change_history, attrs) do
    inventory_change_history
    |> InventoryChangeHistory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory_change_history.

  ## Examples

      iex> delete_inventory_change_history(inventory_change_history)
      {:ok, %InventoryChangeHistory{}}

      iex> delete_inventory_change_history(inventory_change_history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory_change_history(%InventoryChangeHistory{} = inventory_change_history) do
    Repo.delete(inventory_change_history)
  end

  @doc """
  Creates a inventory_metric.

  ## Examples

      iex> create_inventory_metric(%{field: value})
      {:ok, %InventoryMetric{}}

      iex> create_inventory_metric(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory_metric(attrs \\ %{}) do
    %InventoryMetric{}
    |> InventoryMetric.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventory_metric.

  ## Examples

      iex> update_inventory_metric(inventory_metric, %{field: new_value})
      {:ok, %InventoryMetric{}}

      iex> update_inventory_metric(inventory_metric, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory_metric(%InventoryMetric{} = inventory_metric, attrs) do
    inventory_metric
    |> InventoryMetric.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventory_metric.

  ## Examples

      iex> delete_inventory_metric(inventory_metric)
      {:ok, %InventoryMetric{}}

      iex> delete_inventory_metric(inventory_metric)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory_metric(%InventoryMetric{} = inventory_metric) do
    Repo.delete(inventory_metric)
  end

  @doc """
  Returns the list of quality_assurance_requirements.

  ## Examples

      iex> list_quality_assurance_requirements()
      [%QualityAssuranceRequirement{}, ...]

  """
  def list_quality_assurance_requirements do
    Repo.all(QualityAssuranceRequirement)
  end

  @doc """
  Gets a single quality_assurance_requirement.

  Raises `Ecto.NoResultsError` if the Quality assurance requirement does not exist.

  ## Examples

      iex> get_quality_assurance_requirement!(123)
      %QualityAssuranceRequirement{}

      iex> get_quality_assurance_requirement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quality_assurance_requirement!(id), do: Repo.get!(QualityAssuranceRequirement, id)

  @doc """
  Creates a quality_assurance_requirement.

  ## Examples

      iex> create_quality_assurance_requirement(%{field: value})
      {:ok, %QualityAssuranceRequirement{}}

      iex> create_quality_assurance_requirement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quality_assurance_requirement(attrs \\ %{}) do
    %QualityAssuranceRequirement{}
    |> QualityAssuranceRequirement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quality_assurance_requirement.

  ## Examples

      iex> update_quality_assurance_requirement(quality_assurance_requirement, %{field: new_value})
      {:ok, %QualityAssuranceRequirement{}}

      iex> update_quality_assurance_requirement(quality_assurance_requirement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quality_assurance_requirement(
        %QualityAssuranceRequirement{} = quality_assurance_requirement,
        attrs
      ) do
    quality_assurance_requirement
    |> QualityAssuranceRequirement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a quality_assurance_requirement.

  ## Examples

      iex> delete_quality_assurance_requirement(quality_assurance_requirement)
      {:ok, %QualityAssuranceRequirement{}}

      iex> delete_quality_assurance_requirement(quality_assurance_requirement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quality_assurance_requirement(
        %QualityAssuranceRequirement{} = quality_assurance_requirement
      ) do
    Repo.delete(quality_assurance_requirement)
  end

  @doc """
  Creates a purchase.

  ## Examples

      iex> create_purchase(%{field: value})
      {:ok, %Purchase{}}

      iex> create_purchase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_purchase(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a purchase.

  ## Examples

      iex> update_purchase(purchase, %{field: new_value})
      {:ok, %Purchase{}}

      iex> update_purchase(purchase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def approve_purchase(%Purchase{} = purchase) do
    purchase
    |> Purchase.changeset(%{status: "approved"})
    |> Repo.update()
  end

  @doc """
  Deletes a purchase.

  ## Examples

      iex> delete_purchase(purchase)
      {:ok, %Purchase{}}

      iex> delete_purchase(purchase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchase(%Purchase{} = purchase) do
    Repo.delete(purchase)
  end

  def add_purchase_items_to_purchase(attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:purchase, fn repo, _ ->
      purchase_changeset =
        %Purchase{}
        |> Purchase.changeset(attrs)

      purchase =
        Repo.one(
          from(purchase in Purchase,
            join: pickup_centre in assoc(purchase, :pickup_centre),
            where:
              pickup_centre.id == ^attrs.pickup_centre_id and purchase.status == "initialized"
          )
        )

      case purchase do
        nil -> repo.insert(purchase_changeset)
        _ -> {:ok, purchase}
      end
    end)
    |> Multi.run(:purchase_item, fn repo, %{purchase: purchase} ->
      purchase_item_changeset =
        if is_nil(attrs.inventory_id) == false do
          %PurchaseItem{}
          |> PurchaseItem.existing_item_changeset(Map.put(attrs, :purchase_id, purchase.id))
        else
          %PurchaseItem{}
          |> PurchaseItem.unknown_item_changeset(Map.put(attrs, :purchase_id, purchase.id))
        end

      purchase_item =
        if is_nil(attrs.inventory_id) == false do
          Repo.one(
            from(purchase_item in PurchaseItem,
              where:
                purchase_item.inventory_id == ^attrs.inventory_id and
                  purchase_item.purchase_id == ^purchase.id,
              lock: "FOR UPDATE"
            )
          )
        else
          Repo.one(
            from(purchase_item in PurchaseItem,
              where:
                purchase_item.item_name == ^attrs.item_name and
                  purchase_item.purchase_id == ^purchase.id,
              lock: "FOR UPDATE"
            )
          )
        end

      case purchase_item do
        nil ->
          repo.insert(purchase_item_changeset)

        _ ->
          update_purchase_item(purchase_item, %{
            quantity: purchase_item.quantity + attrs.quantity
          })
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a purchase_item.

  ## Examples

      iex> update_purchase_item(purchase_item, %{field: new_value})
      {:ok, %PurchaseItem{}}

      iex> update_purchase_item(purchase_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_purchase_item(%PurchaseItem{} = purchase_item, attrs) do
    purchase_item
    |> PurchaseItem.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a purchase_item.

  ## Examples

      iex> delete_purchase_item(purchase_item)
      {:ok, %PurchaseItem{}}

      iex> delete_purchase_item(purchase_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchase_item(%PurchaseItem{} = purchase_item) do
    Repo.delete(purchase_item)
  end

  alias LetorEcom.Centres.Batch

  @doc """
  Returns the list of batches.

  ## Examples

      iex> list_batches()
      [%Batch{}, ...]

  """
  def list_batches do
    Repo.all(Batch)
  end

  @doc """
  Gets a single batch.

  Raises `Ecto.NoResultsError` if the Batch does not exist.

  ## Examples

      iex> get_batch!(123)
      %Batch{}

      iex> get_batch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_batch!(id), do: Repo.get!(Batch, id)

  @doc """
  Creates a batch.

  ## Examples

      iex> create_batch(%{field: value})
      {:ok, %Batch{}}

      iex> create_batch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_batch(attrs \\ %{}) do
    %Batch{}
    |> Batch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a batch.

  ## Examples

      iex> update_batch(batch, %{field: new_value})
      {:ok, %Batch{}}

      iex> update_batch(batch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_batch(%Batch{} = batch, attrs) do
    batch
    |> Batch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a batch.

  ## Examples

      iex> delete_batch(batch)
      {:ok, %Batch{}}

      iex> delete_batch(batch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_batch(%Batch{} = batch) do
    Repo.delete(batch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking batch changes.

  ## Examples

      iex> change_batch(batch)
      %Ecto.Changeset{data: %Batch{}}

  """
  def change_batch(%Batch{} = batch, attrs \\ %{}) do
    Batch.changeset(batch, attrs)
  end
end
