defmodule LetorEcom.AgentsAndSuppliers do
  @moduledoc """
  The AgentsAndSuppliers context.
  """

  import Ecto.Query, warn: false
  # alias Ecto.Multi
  alias LetorEcom.Repo

  alias LetorEcom.AgentsAndSuppliers.Supplier

  def get_supplier!(id), do: Repo.get!(Supplier, id)

  def create_supplier(attrs \\ %{}) do
    %Supplier{}
    |> Supplier.individual_supplier_changeset(attrs)
    |> Repo.insert()
  end

  def search_supplier(query, nil), do: query

  def search_supplier(query, keywords) do
    pattern = "%#{keywords}%"

    from(
      supplier in query,
      where:
        ilike(supplier.full_name, ^pattern) or
          ilike(supplier.first_name, ^pattern) or
          ilike(supplier.last_name, ^pattern) or
          ilike(supplier.business_name, ^pattern) or
          ilike(supplier.email, ^pattern) or
          ilike(supplier.phone, ^pattern) or
          ilike(supplier.rc_number, ^pattern) or
          ilike(supplier.address, ^pattern)
    )
  end

  @doc """
  Updates a supplier.

  ## Examples

      iex> update_supplier(supplier, %{field: new_value})
      {:ok, %Supplier{}}

      iex> update_supplier(supplier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_supplier(%Supplier{} = supplier, attrs) do
    supplier
    |> Supplier.update_changeset(attrs)
    |> Repo.update()
  end

  def verify_supplier(%Supplier{} = supplier) do
    supplier
    |> Supplier.supplier_verification_changeset(%{verified: true})
    |> Repo.update()
  end

  @doc """
  Deletes a supplier.

  ## Examples

      iex> delete_supplier(supplier)
      {:ok, %Supplier{}}

      iex> delete_supplier(supplier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_supplier(%Supplier{} = supplier) do
    Repo.delete(supplier)
  end
end
