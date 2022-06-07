defmodule LetorEcom.AgentsAndSuppliers do
  @moduledoc """
  The AgentsAndSuppliers context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias LetorEcom.Repo

  alias LetorEcom.AgentsAndSuppliers.Agent

  @doc """
  Creates a agent.

  ## Examples

      iex> create_agent(%{field: value})
      {:ok, %Agent{}}

      iex> create_agent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agent(attrs \\ %{}) do
    agent = %Agent{} |> Agent.changeset(attrs)

    Multi.new()
    |> Multi.insert(:agent, agent)
    |> Multi.run(:agents_uploads, fn repo, %{agent: agent} ->
      agents_uploads_changeset =
        agent
        |> Agent.images_upload_changeset(%{
          agents_image: attrs.agents_image,
          id_image: attrs.id_image
        })

      repo.update(agents_uploads_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a agent.

  ## Examples

      iex> update_agent(agent, %{field: new_value})
      {:ok, %Agent{}}

      iex> update_agent(agent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agent(%Agent{} = agent, attrs) do
    agent
    |> Agent.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a agent.

  ## Examples

      iex> delete_agent(agent)
      {:ok, %Agent{}}

      iex> delete_agent(agent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agent(%Agent{} = agent) do
    Repo.delete(agent)
  end

  alias LetorEcom.AgentsAndSuppliers.Supplier

  @doc """
  Returns the list of suppliers.

  ## Examples

      iex> list_suppliers()
      [%Supplier{}, ...]

  """
  def list_suppliers do
    Repo.all(Supplier)
  end

  @doc """
  Gets a single supplier.

  Raises `Ecto.NoResultsError` if the Supplier does not exist.

  ## Examples

      iex> get_supplier!(123)
      %Supplier{}

      iex> get_supplier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_supplier!(id), do: Repo.get!(Supplier, id)

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
    |> Supplier.changeset(attrs)
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking supplier changes.

  ## Examples

      iex> change_supplier(supplier)
      %Ecto.Changeset{data: %Supplier{}}

  """
  def change_supplier(%Supplier{} = supplier, attrs \\ %{}) do
    Supplier.changeset(supplier, attrs)
  end
end
