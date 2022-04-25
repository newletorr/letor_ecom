defmodule LetorEcom.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo
  alias Ecto.Multi

  alias LetorEcom.Account.{Address, User, ReferedList}
  alias LetorEcom.Transactions.UserWallet

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
end
