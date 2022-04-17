defmodule LetorEcom.Repo.Migrations.CreateInventoryChangeHistory do
  use Ecto.Migration

  def change do
    create table(:inventory_change_history, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :buy_price, :decimal
      add :external_quantity, :integer
      add :internal_quantity, :integer
      add :sales_price, :decimal
      add :change_type, :string
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:inventory_change_history, [:id])
    create index(:inventory_change_history, [:inventory_id])
  end
end
