defmodule LetorEcom.Repo.Migrations.CreateOrdersAssoc do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)
      add :order_dispatch_id, references(:order_dispatches, on_delete: :nothing, type: :binary_id)
      add :agent_id, references(:agents, on_delete: :nothing, type: :binary_id)
      add :address_book_id, references(:address_books, on_delete: :nothing, type: :binary_id)
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)
    end
  end
end
