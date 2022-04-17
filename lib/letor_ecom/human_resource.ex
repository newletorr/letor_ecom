defmodule LetorEcom.HumanResource do
  @moduledoc """
  The HumanResource context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.HumanResource.{Driver, Staff, StaffPosting}

  @doc """
  Returns the list of staff.

  ## Examples

      iex> list_staff()
      [%Staff{}, ...]

  """
  def list_staff do
    Repo.all(Staff)
  end

  @doc """
  Gets a single staff.

  Raises `Ecto.NoResultsError` if the Staff does not exist.

  ## Examples

      iex> get_staff!(123)
      %Staff{}

      iex> get_staff!(456)
      ** (Ecto.NoResultsError)

  """
  def get_staff!(id), do: Repo.get!(Staff, id)

  @doc """
  Creates a staff.

  ## Examples

      iex> create_staff(%{field: value})
      {:ok, %Staff{}}

      iex> create_staff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_staff(attrs \\ %{}) do
    %Staff{}
    |> Staff.changeset(attrs)
    |> Repo.insert()
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
    |> Staff.changeset(attrs)
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
  Returns an `%Ecto.Changeset{}` for tracking staff changes.

  ## Examples

      iex> change_staff(staff)
      %Ecto.Changeset{data: %Staff{}}

  """
  def change_staff(%Staff{} = staff, attrs \\ %{}) do
    Staff.changeset(staff, attrs)
  end

  @doc """
  Returns the list of drivers.

  ## Examples

      iex> list_drivers()
      [%Driver{}, ...]

  """
  def list_drivers do
    Repo.all(Driver)
  end

  @doc """
  Gets a single driver.

  Raises `Ecto.NoResultsError` if the Driver does not exist.

  ## Examples

      iex> get_driver!(123)
      %Driver{}

      iex> get_driver!(456)
      ** (Ecto.NoResultsError)

  """
  def get_driver!(id), do: Repo.get!(Driver, id)

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
  Returns the list of staff_postings.

  ## Examples

      iex> list_staff_postings()
      [%StaffPosting{}, ...]

  """
  def list_staff_postings do
    Repo.all(StaffPosting)
  end

  @doc """
  Gets a single staff_posting.

  Raises `Ecto.NoResultsError` if the Staff posting does not exist.

  ## Examples

      iex> get_staff_posting!(123)
      %StaffPosting{}

      iex> get_staff_posting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_staff_posting!(id), do: Repo.get!(StaffPosting, id)

  @doc """
  Creates a stores postings

  ## Examples

      iex> create_stores_posting(%{field: value})
      {:ok, %StaffPosting{}}

      iex> create_stores_posting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stores_posting(attrs \\ %{}) do
    %StaffPosting{}
    |> StaffPosting.stores_postings_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a Control postings

  ## Examples

      iex> create_control_posting(%{field: value})
      {:ok, %StaffPosting{}}

      iex> create_control_posting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_control_posting(attrs \\ %{}) do
    %StaffPosting{}
    |> StaffPosting.control_postings_changeset(attrs)
    |> Repo.insert()
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
