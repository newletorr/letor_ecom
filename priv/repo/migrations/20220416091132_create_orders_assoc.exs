defmodule LetorEcom.Repo.Migrations.CreateOrdersAssoc do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)
      add :location_id, references(:location, on_delete: :nothing, type: :binary_id)
      add :order_dispatch_id, references(:order_dispatches, on_delete: :nothing, type: :binary_id)
    end
  end
end
