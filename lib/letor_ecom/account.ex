defmodule LetorEcom.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo
  alias Ecto.Multi

  alias LetorEcom.Account.{AddressBook, ReferedList, ShoppingList, User, UserFav, ViewedItem}
  alias LetorEcom.AgentsAndSuppliers.{Agent, Supplier}
  alias LetorEcom.HumanResource.Staff
  alias LetorEcom.Transactions.UserWallet

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_customer(attrs \\ %{}) do
    user_changeset = %User{} |> User.changeset(attrs)

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.run(:user_wallet, fn repo, %{user: user} ->
      user_wallet_changeset =
        %UserWallet{}
        |> UserWallet.changeset(%{user_id: user.id})

      repo.insert(user_wallet_changeset)
    end)
    |> Repo.transaction()
  end

  def register_agent(attrs \\ %{}) do
    agent_changeset = %Agent{} |> Agent.changeset(attrs)

    Multi.new()
    |> Multi.insert(:agent, agent_changeset)
    |> Multi.run(:user, fn repo, %{agent: agent} ->
      user_changeset =
        %User{}
        |> User.agent_changeset(Map.put(attrs, :agent_id, agent.id))

      repo.insert(user_changeset)
    end)
    |> Repo.transaction()
  end

  def register_supplier(attrs \\ %{}) do
    supplier_changeset =
      if attrs.type == "individual" do
        %Supplier{} |> Supplier.individual_supplier_changeset(attrs)
      else
        %Supplier{} |> Supplier.corporate_supplier_changeset(attrs)
      end

    Multi.new()
    |> Multi.insert(:supplier, supplier_changeset)
    |> Multi.run(:user, fn repo, %{supplier: supplier} ->
      user_changeset =
        %User{}
        |> User.supplier_changeset(Map.put(attrs, :supplier_id, supplier.id))

      repo.insert(user_changeset)
    end)
    |> Repo.transaction()
  end

  def update_supplier_profile(supplier_user, attrs) do
    user_changeset = supplier_user |> User.update_changeset(attrs)

    supplier =
      Repo.one(
        from supplier in Supplier,
          join: user in assoc(supplier, :users),
          where: user.id == ^supplier_user.id
      )

    supplier_changeset = supplier |> Supplier.update_changeset(attrs)

    Multi.new()
    |> Multi.update(:user, user_changeset)
    |> Multi.run(:supplier, fn repo, _ ->
      repo.update(supplier_changeset)
    end)
    |> Repo.transaction()
  end

  def register_staff(attrs \\ %{}) do
    staff_changeset = %Staff{} |> Staff.changeset(attrs)

    Multi.new()
    |> Multi.insert(:staff, staff_changeset)
    |> Multi.run(:user, fn repo, %{staff: staff} ->
      user_changeset =
        %User{}
        |> User.staff_changeset(Map.put(attrs, :staff_id, staff.id))

      repo.insert(user_changeset)
    end)
    |> Repo.transaction()
  end

  def update_staff_profile(staff_user, attrs) do
    user_changeset = staff_user |> User.update_changeset(attrs)

    staff =
      Repo.one(
        from staff in Staff,
          join: user in assoc(staff, :users),
          where: user.id == ^staff_user.id
      )

    staff_changeset = staff |> Staff.update_changeset(attrs)

    Multi.new()
    |> Multi.update(:user, user_changeset)
    |> Multi.run(:supplier, fn repo, _ ->
      repo.update(staff_changeset)
    end)
    |> Repo.transaction()
  end

  def update_customer_referal_points_earned(%User{} = user, attrs) do
    user
    |> User.update_referals_earned_changeset(attrs)
    |> Repo.update()
  end

  def update_tracked_fields(%User{} = user, remote_ip) do
    attrs = %{
      current_sign_in_at: Timex.now(),
      last_sign_in_at: user.current_sign_in_at,
      current_sign_in_ip: remote_ip,
      sign_in_count: user.sign_in_count + 1
    }

    attrs =
      case user.current_sign_in_ip != remote_ip do
        true -> Map.put(attrs, :last_sign_in_ip, user.current_sign_in_ip)
        _ -> attrs
      end

    user
    |> User.tracked_fields_changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Change users password
  """
  def change_password(user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates a address_book.

  ## Examples

      iex> create_address_book(%{field: value})
      {:ok, %AddressBook{}}

      iex> create_address_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address_book(attrs \\ %{}) do
    %AddressBook{}
    |> AddressBook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address_book.

  ## Examples

      iex> update_address_book(address_book, %{field: new_value})
      {:ok, %AddressBook{}}

      iex> update_address_book(address_book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address_book(%AddressBook{} = address_book, attrs) do
    address_book
    |> AddressBook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address_book.

  ## Examples

      iex> delete_address_book(address_book)
      {:ok, %AddressBook{}}

      iex> delete_address_book(address_book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address_book(%AddressBook{} = address_book) do
    address_book
    |> AddressBook.deletion_changeset()
    |> Repo.delete()
  end

  @doc """
  Get longitude value for pickup centre
  """
  def get_coordinates(coord) do
    {:ok, json} = Geo.JSON.encode(coord)

    case json do
      nil ->
        {:error, "Error getting value"}

      _ ->
        {:ok, json["coordinates"]}
    end
  end

  @doc """
  Creates a refered_list.

  ## Examples

      iex> create_refered_list(%{field: value})
      {:ok, %ReferedList{}}

      iex> create_refered_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_refered_list(attrs \\ %{}) do
    %ReferedList{}
    |> ReferedList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a refered_list.

  ## Examples

      iex> update_refered_list(refered_list, %{field: new_value})
      {:ok, %ReferedList{}}

      iex> update_refered_list(refered_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_refered_list(%ReferedList{} = refered_list, attrs) do
    refered_list
    |> ReferedList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a refered_list.

  ## Examples

      iex> delete_refered_list(refered_list)
      {:ok, %ReferedList{}}

      iex> delete_refered_list(refered_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_refered_list(%ReferedList{} = refered_list) do
    Repo.delete(refered_list)
  end

  @doc """
  Creates a shopping_list.

  ## Examples

      iex> create_shopping_list(%{field: value})
      {:ok, %ShoppingList{}}

      iex> create_shopping_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shopping_list(attrs \\ %{}) do
    %ShoppingList{}
    |> ShoppingList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shopping_list.

  ## Examples

      iex> update_shopping_list(shopping_list, %{field: new_value})
      {:ok, %ShoppingList{}}

      iex> update_shopping_list(shopping_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shopping_list(%ShoppingList{} = shopping_list, attrs) do
    update_shopping_list_changeset = shopping_list |> ShoppingList.update_changeset(attrs)

    shopping_list =
      Repo.one(
        from(shopping_list in ShoppingList,
          where:
            shopping_list.user_id == ^attrs.user_id and
              shopping_list.title == ^shopping_list.title and
              shopping_list.item_id == ^attrs.item_id
        )
      )

    case shopping_list do
      nil ->
        Repo.update(update_shopping_list_changeset)

      _ ->
        update_shopping_list_quantity(shopping_list, %{
          quantity: shopping_list.quantity + attrs.quantity
        })
    end
  end

  def update_shopping_list_quantity(%ShoppingList{} = shopping_list, attrs) do
    shopping_list
    |> ShoppingList.quantity_update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shopping_list.

  ## Examples

      iex> delete_shopping_list(shopping_list)
      {:ok, %ShoppingList{}}
  Account
      iex> delete_shopping_list(shopping_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shopping_list(%ShoppingList{} = shopping_list) do
    Repo.delete(shopping_list)
  end

  @doc """
  Returns the list of user_favs.

  ## Examples

      iex> list_user_favs()
      [%UserFav{}, ...]

  """
  def list_user_favs do
    Repo.all(UserFav)
  end

  @doc """
  Gets a single user_fav.

  Raises `Ecto.NoResultsError` if the User fav does not exist.

  ## Examples

      iex> get_user_fav!(123)
      %UserFav{}

      iex> get_user_fav!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_fav!(id), do: Repo.get!(UserFav, id)

  @doc """
  Creates a user_fav.

  ## Examples

      iex> create_user_fav(%{field: value})
      {:ok, %UserFav{}}

      iex> create_user_fav(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_fav(attrs \\ %{}) do
    %UserFav{}
    |> UserFav.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_fav.

  ## Examples

      iex> update_user_fav(user_fav, %{field: new_value})
      {:ok, %UserFav{}}

      iex> update_user_fav(user_fav, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_fav(%UserFav{} = user_fav, attrs) do
    user_fav
    |> UserFav.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_fav.

  ## Examples

      iex> delete_user_fav(user_fav)
      {:ok, %UserFav{}}

      iex> delete_user_fav(user_fav)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_fav(%UserFav{} = user_fav) do
    Repo.delete(user_fav)
  end

  @doc """
  Returns the list of viewed_items.

  ## Examples

      iex> list_viewed_items()
      [%ViewedItem{}, ...]

  """
  def list_viewed_items do
    Repo.all(ViewedItem)
  end

  @doc """
  Gets a single viewed_item.

  Raises `Ecto.NoResultsError` if the Viewed item does not exist.

  ## Examples

      iex> get_viewed_item!(123)
      %ViewedItem{}

      iex> get_viewed_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_viewed_item!(id), do: Repo.get!(ViewedItem, id)

  @doc """
  Creates a viewed_item.

  ## Examples

      iex> create_viewed_item(%{field: value})
      {:ok, %ViewedItem{}}

      iex> create_viewed_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_viewed_item(attrs \\ %{}) do
    viewed_item_changeset = %ViewedItem{} |> ViewedItem.changeset(attrs)

    Multi.new()
    |> Multi.insert(:viewed_item, viewed_item_changeset)
    |> Multi.run(:viewed_item_update, fn repo, _ ->
      count =
        Repo.one(
          from view_item in ViewedItem,
            where: view_item.user_id == ^attrs.user_id,
            select: count("*")
        )

      query = from(view_item in ViewedItem, where: view_item.user_id == ^attrs.user_id)
      oldest_viewed_item = query |> first(:inserted_at) |> Repo.one()

      if count >= 11 do
        repo.delete(oldest_viewed_item)
      else
        {:ok, nil}
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a viewed_item.

  ## Examples

      iex> update_viewed_item(viewed_item, %{field: new_value})
      {:ok, %ViewedItem{}}

      iex> update_viewed_item(viewed_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_viewed_item(%ViewedItem{} = viewed_item, attrs) do
    viewed_item
    |> ViewedItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a viewed_item.

  ## Examples

      iex> delete_viewed_item(viewed_item)
      {:ok, %ViewedItem{}}

      iex> delete_viewed_item(viewed_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_viewed_item(%ViewedItem{} = viewed_item) do
    Repo.delete(viewed_item)
  end
end
