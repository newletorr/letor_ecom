defmodule LetorEcom.Repo do
  import Ecto.Query, warn: false

  use Ecto.Repo,
    otp_app: :letor_ecom,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end

  @spec count(any()) :: any()
  def count(query) do
    one(from(r in query, select: count("*")))
  end

  @spec paginate(any(), any(), any()) :: Ecto.Query.t()
  def paginate(query, offset, limit) do
    from(r in query, offset: ^offset, limit: ^limit)
  end

  @spec fetch(any) :: {:error, any} | {:ok, any}
  def fetch(query) do
    case all(query) do
      [] -> {:error, query}
      [obj] -> {:ok, obj}
    end
  end
end
