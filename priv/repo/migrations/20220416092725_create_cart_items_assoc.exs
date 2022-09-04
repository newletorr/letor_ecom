defmodule LetorEcom.Repo.Migrations.CreateCartItemsAssoc do
  use Ecto.Migration

  def change do
    alter table(:cart_items) do
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id)
    end

    create index(:cart_items, [:item_id])
    create index(:cart_items, [:order_id])
  end
end
