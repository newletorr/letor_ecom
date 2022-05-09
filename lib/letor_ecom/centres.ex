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
    InventoryLocation,
    InventoryMetric
  }

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
end
