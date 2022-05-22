defmodule LetorEcom.Repo.Migrations.CreateUserAssoc do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)
    end
  end
end
