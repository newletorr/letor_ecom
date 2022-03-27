defmodule LetorEcom.Control do
  @moduledoc """
  The Control context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Control.{CentreCode, EcommerceControl}

  @doc """
  Returns the list of centre_code.

  ## Examples

      iex> list_centre_code()
      [%CentreCode{}, ...]

  """
  def list_centre_code do
    Repo.all(CentreCode)
  end

  @doc """
  Gets a single centre_code.

  Raises `Ecto.NoResultsError` if the Centre code does not exist.

  ## Examples

      iex> get_centre_code!(123)
      %CentreCode{}

      iex> get_centre_code!(456)
      ** (Ecto.NoResultsError)

  """
  def get_centre_code!(id), do: Repo.get!(CentreCode, id)

  @doc """
  Creates a centre_code.

  ## Examples

      iex> create_centre_code(%{field: value})
      {:ok, %CentreCode{}}

      iex> create_centre_code(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_centre_code(attrs \\ %{}) do
    %CentreCode{}
    |> CentreCode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a centre_code.

  ## Examples

      iex> update_centre_code(centre_code, %{field: new_value})
      {:ok, %CentreCode{}}

      iex> update_centre_code(centre_code, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_centre_code(%CentreCode{} = centre_code, attrs) do
    centre_code
    |> CentreCode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a centre_code.

  ## Examples

      iex> delete_centre_code(centre_code)
      {:ok, %CentreCode{}}

      iex> delete_centre_code(centre_code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_centre_code(%CentreCode{} = centre_code) do
    Repo.delete(centre_code)
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
end
