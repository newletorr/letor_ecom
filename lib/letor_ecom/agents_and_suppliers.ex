defmodule LetorEcom.AgentsAndSuppliers do
  @moduledoc """
  The AgentsAndSuppliers context.
  """

  import Ecto.Query, warn: false
  alias LetorEcom.Repo

  alias LetorEcom.AgentsAndSuppliers.CampusAgent

  @doc """
  Returns the list of campus_agents.

  ## Examples

      iex> list_campus_agents()
      [%CampusAgent{}, ...]

  """
  def list_campus_agents do
    Repo.all(CampusAgent)
  end

  @doc """
  Gets a single campus_agent.

  Raises `Ecto.NoResultsError` if the Campus agent does not exist.

  ## Examples

      iex> get_campus_agent!(123)
      %CampusAgent{}

      iex> get_campus_agent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campus_agent!(id), do: Repo.get!(CampusAgent, id)

  @doc """
  Creates a campus_agent.

  ## Examples

      iex> create_campus_agent(%{field: value})
      {:ok, %CampusAgent{}}

      iex> create_campus_agent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campus_agent(attrs \\ %{}) do
    %CampusAgent{}
    |> CampusAgent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campus_agent.

  ## Examples

      iex> update_campus_agent(campus_agent, %{field: new_value})
      {:ok, %CampusAgent{}}

      iex> update_campus_agent(campus_agent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campus_agent(%CampusAgent{} = campus_agent, attrs) do
    campus_agent
    |> CampusAgent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a campus_agent.

  ## Examples

      iex> delete_campus_agent(campus_agent)
      {:ok, %CampusAgent{}}

      iex> delete_campus_agent(campus_agent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campus_agent(%CampusAgent{} = campus_agent) do
    Repo.delete(campus_agent)
  end
end
