defmodule LetorEcom.Delicacies do
  @moduledoc """
  The Delicacies context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Delicacies.RecipeClass

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  @doc """
  Creates a recipe_class.

  ## Examples

      iex> create_recipe_class(%{field: value})
      {:ok, %RecipeClass{}}

      iex> create_recipe_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_class(attrs \\ %{}) do
    %RecipeClass{}
    |> RecipeClass.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_class.

  ## Examples

      iex> update_recipe_class(recipe_class, %{field: new_value})
      {:ok, %RecipeClass{}}

      iex> update_recipe_class(recipe_class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_class(%RecipeClass{} = recipe_class, attrs) do
    recipe_class
    |> RecipeClass.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe_class.

  ## Examples

      iex> delete_recipe_class(recipe_class)
      {:ok, %RecipeClass{}}

      iex> delete_recipe_class(recipe_class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe_class(%RecipeClass{} = recipe_class) do
    Repo.delete(recipe_class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_class changes.

  ## Examples

      iex> change_recipe_class(recipe_class)
      %Ecto.Changeset{data: %RecipeClass{}}

  """
  def change_recipe_class(%RecipeClass{} = recipe_class, attrs \\ %{}) do
    RecipeClass.changeset(recipe_class, attrs)
  end

  alias LetorEcom.Delicacies.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  alias LetorEcom.Delicacies.ItemRecipe

  @doc """
  Returns the list of item_recipes.

  ## Examples

      iex> list_item_recipes()
      [%ItemRecipe{}, ...]

  """
  def list_item_recipes do
    Repo.all(ItemRecipe)
  end

  @doc """
  Gets a single item_recipe.

  Raises `Ecto.NoResultsError` if the Item recipe does not exist.

  ## Examples

      iex> get_item_recipe!(123)
      %ItemRecipe{}

      iex> get_item_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_recipe!(id), do: Repo.get!(ItemRecipe, id)

  @doc """
  Creates a item_recipe.

  ## Examples

      iex> create_item_recipe(%{field: value})
      {:ok, %ItemRecipe{}}

      iex> create_item_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_recipe(attrs \\ %{}) do
    %ItemRecipe{}
    |> ItemRecipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_recipe.

  ## Examples

      iex> update_item_recipe(item_recipe, %{field: new_value})
      {:ok, %ItemRecipe{}}

      iex> update_item_recipe(item_recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_recipe(%ItemRecipe{} = item_recipe, attrs) do
    item_recipe
    |> ItemRecipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_recipe.

  ## Examples

      iex> delete_item_recipe(item_recipe)
      {:ok, %ItemRecipe{}}

      iex> delete_item_recipe(item_recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_recipe(%ItemRecipe{} = item_recipe) do
    Repo.delete(item_recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_recipe changes.

  ## Examples

      iex> change_item_recipe(item_recipe)
      %Ecto.Changeset{data: %ItemRecipe{}}

  """
  def change_item_recipe(%ItemRecipe{} = item_recipe, attrs \\ %{}) do
    ItemRecipe.changeset(item_recipe, attrs)
  end

  alias LetorEcom.Delicacies.UserRecipe

  @doc """
  Returns the list of user_recipes.

  ## Examples

      iex> list_user_recipes()
      [%UserRecipe{}, ...]

  """
  def list_user_recipes do
    Repo.all(UserRecipe)
  end

  @doc """
  Gets a single user_recipe.

  Raises `Ecto.NoResultsError` if the User recipe does not exist.

  ## Examples

      iex> get_user_recipe!(123)
      %UserRecipe{}

      iex> get_user_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_recipe!(id), do: Repo.get!(UserRecipe, id)

  @doc """
  Creates a user_recipe.

  ## Examples

      iex> create_user_recipe(%{field: value})
      {:ok, %UserRecipe{}}

      iex> create_user_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_recipe(attrs \\ %{}) do
    %UserRecipe{}
    |> UserRecipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_recipe.

  ## Examples

      iex> update_user_recipe(user_recipe, %{field: new_value})
      {:ok, %UserRecipe{}}

      iex> update_user_recipe(user_recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_recipe(%UserRecipe{} = user_recipe, attrs) do
    user_recipe
    |> UserRecipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_recipe.

  ## Examples

      iex> delete_user_recipe(user_recipe)
      {:ok, %UserRecipe{}}

      iex> delete_user_recipe(user_recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_recipe(%UserRecipe{} = user_recipe) do
    Repo.delete(user_recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_recipe changes.

  ## Examples

      iex> change_user_recipe(user_recipe)
      %Ecto.Changeset{data: %UserRecipe{}}

  """
  def change_user_recipe(%UserRecipe{} = user_recipe, attrs \\ %{}) do
    UserRecipe.changeset(user_recipe, attrs)
  end
end
