defmodule LetorEcom.Repo.Migrations.CreateDeliveryCharges do
  use Ecto.Migration

  def change do
    create table(:delivery_charges, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :eight_to_twelve, :decimal
      add :four_to_ten, :decimal
      add :fifteen_to_thirty_minutes, :decimal
      add :twelve_to_four, :decimal

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:delivery_charges, [:id])
    create index(:delivery_charges, [:ecommerce_control_id])
  end
end
