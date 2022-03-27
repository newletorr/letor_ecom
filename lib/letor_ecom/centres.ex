defmodule LetorEcom.Centres do
  @moduledoc """
  The Centres context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.Centres.PickupCentre

  @doc """
  Returns the list of pickup_centres.

  ## Examples

      iex> list_pickup_centres()
      [%PickupCentre{}, ...]

  """
  def list_pickup_centres do
    Repo.all(PickupCentre)
  end

  @doc """
  Gets a single pickup_centre.

  Raises `Ecto.NoResultsError` if the Pickup centre does not exist.

  ## Examples

      iex> get_pickup_centre!(123)
      %PickupCentre{}

      iex> get_pickup_centre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pickup_centre!(id), do: Repo.get!(PickupCentre, id)

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
end
