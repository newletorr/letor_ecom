defmodule LetorEcom.HumanResource do
  @moduledoc """
  The HumanResource context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.HumanResource.{Driver, Staff, StaffPosting}

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  @doc """
  Updates a staff.

  ## Examples

      iex> update_staff(staff, %{field: new_value})
      {:ok, %Staff{}}

      iex> update_staff(staff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_staff(%Staff{} = staff, attrs) do
    staff
    |> Staff.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a staff.

  ## Examples

      iex> delete_staff(staff)
      {:ok, %Staff{}}

      iex> delete_staff(staff)
      {:error, %Ecto.Changeset{}}

  """
  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  @doc """
  Creates a driver.

  ## Examples

      iex> create_driver(%{field: value})
      {:ok, %Driver{}}

      iex> create_driver(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_driver(attrs \\ %{}) do
    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a driver.

  ## Examples

      iex> update_driver(driver, %{field: new_value})
      {:ok, %Driver{}}

      iex> update_driver(driver, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a driver.

  ## Examples

      iex> delete_driver(driver)
      {:ok, %Driver{}}

      iex> delete_driver(driver)
      {:error, %Ecto.Changeset{}}

  """
  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  @doc """
  Creates a stores postings

  ## Examples

      iex> create_stores_posting(%{field: value})
      {:ok, %StaffPosting{}}

      iex> create_stores_posting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_posting(attrs \\ %{}) do
    staff_posting_changeset =
      if is_nil(attrs.ecommerce_control_id) == false do
        %StaffPosting{} |> StaffPosting.control_postings_changeset(attrs)
      else
        %StaffPosting{} |> StaffPosting.stores_postings_changeset(attrs)
      end

    staff_posting_changeset |> Repo.insert()
  end

  @doc """
  Updates a staff_posting.

  ## Examples

      iex> update_staff_posting(staff_posting, %{field: new_value})
      {:ok, %StaffPosting{}}

      iex> update_staff_posting(staff_posting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_staff_posting(%StaffPosting{} = staff_posting, attrs) do
    staff_posting
    |> StaffPosting.posting_update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a staff_posting.

  ## Examples

      iex> delete_staff_posting(staff_posting)
      {:ok, %StaffPosting{}}

      iex> delete_staff_posting(staff_posting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_staff_posting(%StaffPosting{} = staff_posting) do
    Repo.delete(staff_posting)
  end
end
