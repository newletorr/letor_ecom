defmodule LetorEcom.Repo.Migrations.CreatePurchaseOrders do
  use Ecto.Migration

  def change do
    create table(:purchase_orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:state, :string)
      add(:fob_point, :string)
      add(:po_number, :string)
      add(:shipping_and_handling, :decimal)
      add(:tax_rate, :float)
      add(:terms_and_conditions, :string)

      add(
        :ecommerce_control_id,
        references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)
      )

      add(:supplier_id, references(:suppliers, on_delete: :nothing, type: :binary_id))

      timestamps(type: :timestamptz)
    end

    create(index(:purchase_orders, [:id]))
    create(index(:purchase_orders, [:ecommerce_control_id]))
    create(index(:purchase_orders, [:supplier_id]))
  end
end
