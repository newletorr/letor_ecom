defmodule LetorEcom.Catalogue do
  @moduledoc """
  The Catalogue context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Catalogue.{Item, ItemCategory, ItemSubcategory, Sku}

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
end
