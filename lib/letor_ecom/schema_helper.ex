defmodule LetorEcom.SchemaHelper do
  @moduledoc "Ecto Schema Helpers"

  @spec __using__(any) ::
          {:__block__, [],
           [{:@, [...], [...]} | {:import, [...], [...]} | {:use, [...], [...]}, ...]}
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      @primary_key {:id, :binary_id, read_after_writes: true}
      @foreign_key_type :binary_id
    end
  end
end
