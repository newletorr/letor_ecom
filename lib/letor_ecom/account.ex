defmodule LetorEcom.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo
  alias Ecto.Multi

  alias LetorEcom.Account.{Address, User}
  alias LetorEcom.Transactions.UserWallet

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

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

  def update_cus_pat_referal_points_earned(%User{} = user, attrs) do
    user
    |> User.update_referals_earned_changeset(attrs)
    |> Repo.update()
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
    |> User.changeset(attrs)
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
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    Repo.all(Address)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  alias LetorEcom.Account.ReferedList

  @doc """
  Returns the list of refered_lists.

  ## Examples

      iex> list_refered_lists()
      [%ReferedList{}, ...]

  """
  def list_refered_lists do
    Repo.all(ReferedList)
  end

  @doc """
  Gets a single refered_list.

  Raises `Ecto.NoResultsError` if the Refered list does not exist.

  ## Examples

      iex> get_refered_list!(123)
      %ReferedList{}

      iex> get_refered_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_refered_list!(id), do: Repo.get!(ReferedList, id)

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
  Returns an `%Ecto.Changeset{}` for tracking refered_list changes.

  ## Examples

      iex> change_refered_list(refered_list)
      %Ecto.Changeset{data: %ReferedList{}}

  """
  def change_refered_list(%ReferedList{} = refered_list, attrs \\ %{}) do
    ReferedList.changeset(refered_list, attrs)
  end
end
