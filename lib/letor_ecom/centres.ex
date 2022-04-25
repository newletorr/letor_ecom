defmodule LetorEcom.Centres do
  @moduledoc """
  The Centres context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo
  # alias LetorEcom.Catalogue.{Item, Sku}

  alias LetorEcom.Centres.{
    DailyDeal,
    FeaturedItem,
    PickupCentre,
    PopularItem,
    Inventory,
    InventoryChangeHistory,
    InventoryLocation
  }

  @doc """
  Returns the list of pickup_centres.

  ## Examples

      iex> list_pickup_centres()
      [%PickupCentre{}, ...]

  """
  def list_pickup_centres do
    Repo.all(PickupCentre)
  end

  @doc """
  Gets a single pickup_centre.

  Raises `Ecto.NoResultsError` if the Pickup centre does not exist.

  ## Examples

      iex> get_pickup_centre!(123)
      %PickupCentre{}

      iex> get_pickup_centre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pickup_centre!(id), do: Repo.get!(PickupCentre, id)

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
  Returns the list of inventory_location.

  ## Examples

      iex> list_inventory_location()
      [%InventoryLocation{}, ...]

  """
  def list_inventory_location do
    Repo.all(InventoryLocation)
  end

  @doc """
  Gets a single inventory_location.

  Raises `Ecto.NoResultsError` if the Inventory location does not exist.

  ## Examples

      iex> get_inventory_location!(123)
      %InventoryLocation{}

      iex> get_inventory_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory_location!(id), do: Repo.get!(InventoryLocation, id)

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
  Returns the list of daily_deals.

  ## Examples

      iex> list_daily_deals()
      [%DailyDeal{}, ...]

  """
  def list_daily_deals do
    Repo.all(DailyDeal)
  end

  @doc """
  Gets a single daily_deal.

  Raises `Ecto.NoResultsError` if the Daily deal does not exist.

  ## Examples

      iex> get_daily_deal!(123)
      %DailyDeal{}

      iex> get_daily_deal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_deal!(id), do: Repo.get!(DailyDeal, id)

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
  Returns the list of popular_items.

  ## Examples

      iex> list_popular_items()
      [%PopularItem{}, ...]

  """
  def list_popular_items do
    Repo.all(PopularItem)
  end

  @doc """
  Gets a single popular_item.

  Raises `Ecto.NoResultsError` if the Popular item does not exist.

  ## Examples

      iex> get_popular_item!(123)
      %PopularItem{}

      iex> get_popular_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_popular_item!(id), do: Repo.get!(PopularItem, id)

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
  Returns the list of featured_items.

  ## Examples

      iex> list_featured_items()
      [%FeaturedItem{}, ...]

  """
  def list_featured_items do
    Repo.all(FeaturedItem)
  end

  @doc """
  Gets a single featured_item.

  Raises `Ecto.NoResultsError` if the Featured item does not exist.

  ## Examples

      iex> get_featured_item!(123)
      %FeaturedItem{}

      iex> get_featured_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_featured_item!(id), do: Repo.get!(FeaturedItem, id)

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

  @doc """
  Returns the list of inventories.

  ## Examples

      iex> list_inventories()
      [%Inventory{}, ...]

  """
  def list_inventories do
    Repo.all(Inventory)
  end

  @doc """
  Gets a single inventory.

  Raises `Ecto.NoResultsError` if the Inventory does not exist.

  ## Examples

      iex> get_inventory!(123)
      %Inventory{}

      iex> get_inventory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory!(id), do: Repo.get!(Inventory, id)

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
    |> Inventory.changeset(attrs)
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
  Returns the list of inventory_change_history.

  ## Examples

      iex> list_inventory_change_history()
      [%InventoryChangeHistory{}, ...]

  """
  def list_inventory_change_history do
    Repo.all(InventoryChangeHistory)
  end

  @doc """
  Gets a single inventory_change_history.

  Raises `Ecto.NoResultsError` if the Inventory change history does not exist.

  ## Examples

      iex> get_inventory_change_history!(123)
      %InventoryChangeHistory{}

      iex> get_inventory_change_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory_change_history!(id), do: Repo.get!(InventoryChangeHistory, id)

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
end
