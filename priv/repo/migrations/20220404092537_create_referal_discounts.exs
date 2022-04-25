defmodule LetorEcom.Repo.Migrations.CreateReferalDiscounts do
  use Ecto.Migration

  def change do
    create table(:referal_discounts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :first_discount, :decimal
      add :second_discount, :decimal
      add :third_discount, :decimal
      add :fourth_discount, :decimal

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:referal_discounts, [:id])
    create index(:referal_discounts, [:ecommerce_control_id])
  end
end
