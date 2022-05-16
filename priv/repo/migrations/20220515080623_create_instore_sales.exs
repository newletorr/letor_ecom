defmodule LetorEcom.Repo.Migrations.CreateInstoreSales do
  use Ecto.Migration

  def change do
    create table(:instore_sales, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer
      add :item_price, :decimal
      add :sales_amount, :decimal
      add :sale_id, references(:sales, on_delete: :nothing, type: :binary_id)
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:instore_sales, [:sale_id])
    create index(:instore_sales, [:item_id])
  end
end
