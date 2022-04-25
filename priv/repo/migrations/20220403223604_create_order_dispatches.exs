defmodule LetorEcom.Repo.Migrations.CreateOrderDispatches do
  use Ecto.Migration

  def change do
    create table(:order_dispatches, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :dispatched, :boolean, default: false, null: false
      add :order_count, :integer
      add :order_delivered, :integer
      add :dispatch_id, :string
      add :delayed, :boolean, default: false, null: false
      add :all_delivered, :boolean, default: false, null: false
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)
      add :driver_id, references(:drivers, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create(index(:order_dispatches, [:id]))
    create(index(:order_dispatches, [:driver_id]))
    create(index(:order_dispatches, [:pickup_centre_id]))

    create(
      unique_index(:order_dispatches, [:staff_id, :dispatched],
        name: "order_dispatches_staff_id_dispatched_index",
        where: "dispatched = false"
      )
    )
  end
end
