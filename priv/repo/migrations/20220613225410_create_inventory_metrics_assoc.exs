defmodule LetorEcom.Repo.Migrations.CreateInventoryMetricsAssoc do
  use Ecto.Migration

  def change do
    alter table(:inventory_metrics) do
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)
    end

    create index(:inventory_metrics, [:inventory_id])
  end
end
