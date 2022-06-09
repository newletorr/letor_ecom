defmodule LetorEcom.Control do
  @moduledoc """
  The Control context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Control.{CoveredInstitution, EcommerceControl, Location}

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  @doc """
  Returns the list of ecommerce_controls.

  ## Examples

      iex> list_ecommerce_controls()
      [%EcommerceControl{}, ...]

  """
  def list_ecommerce_controls do
    Repo.all(EcommerceControl)
  end

  @doc """
  Gets a single ecommerce_control.

  Raises `Ecto.NoResultsError` if the Ecommerce control does not exist.

  ## Examples

      iex> get_ecommerce_control!(123)
      %EcommerceControl{}

      iex> get_ecommerce_control!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ecommerce_control!(id), do: Repo.get!(EcommerceControl, id)

  @doc """
  Creates a ecommerce_control.

  ## Examples

      iex> create_ecommerce_control(%{field: value})
      {:ok, %EcommerceControl{}}

      iex> create_ecommerce_control(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ecommerce_control(attrs \\ %{}) do
    %EcommerceControl{}
    |> EcommerceControl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ecommerce_control.

  ## Examples

      iex> update_ecommerce_control(ecommerce_control, %{field: new_value})
      {:ok, %EcommerceControl{}}

      iex> update_ecommerce_control(ecommerce_control, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ecommerce_control(%EcommerceControl{} = ecommerce_control, attrs) do
    ecommerce_control
    |> EcommerceControl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ecommerce_control.

  ## Examples

      iex> delete_ecommerce_control(ecommerce_control)
      {:ok, %EcommerceControl{}}

      iex> delete_ecommerce_control(ecommerce_control)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ecommerce_control(%EcommerceControl{} = ecommerce_control) do
    Repo.delete(ecommerce_control)
  end

  @doc """
  Returns the list of location.

  ## Examples

      iex> list_location()
      [%Location{}, ...]

  """
  def list_location do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns the list of covered_institutions.

  ## Examples

      iex> list_covered_institutions()
      [%CoveredInstitution{}, ...]

  """
  def list_covered_institutions do
    Repo.all(CoveredInstitution)
  end

  @doc """
  Gets a single covered_institution.

  Raises `Ecto.NoResultsError` if the Covered institution does not exist.

  ## Examples

      iex> get_covered_institution!(123)
      %CoveredInstitution{}

      iex> get_covered_institution!(456)
      ** (Ecto.NoResultsError)

  """
  def get_covered_institution!(id), do: Repo.get!(CoveredInstitution, id)

  @doc """
  Creates a covered_institution.

  ## Examples

      iex> create_covered_institution(%{field: value})
      {:ok, %CoveredInstitution{}}

      iex> create_covered_institution(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_covered_institution(attrs \\ %{}) do
    %CoveredInstitution{}
    |> CoveredInstitution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a covered_institution.

  ## Examples

      iex> update_covered_institution(covered_institution, %{field: new_value})
      {:ok, %CoveredInstitution{}}

      iex> update_covered_institution(covered_institution, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_covered_institution(%CoveredInstitution{} = covered_institution, attrs) do
    covered_institution
    |> CoveredInstitution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a covered_institution.

  ## Examples

      iex> delete_covered_institution(covered_institution)
      {:ok, %CoveredInstitution{}}

      iex> delete_covered_institution(covered_institution)
      {:error, %Ecto.Changeset{}}

  """
  def delete_covered_institution(%CoveredInstitution{} = covered_institution) do
    Repo.delete(covered_institution)
  end
end
