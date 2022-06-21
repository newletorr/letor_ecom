defmodule LetorEcom.Repo.Migrations.CreateInventoryChangeHistoryAssoc do
  use Ecto.Migration

  def change do
    alter table(:inventory_change_history) do
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)
    end

    create index(:inventory_change_history, [:inventory_id])
  end
end
