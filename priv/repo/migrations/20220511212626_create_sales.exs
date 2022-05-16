defmodule LetorEcom.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :quantity, :integer
      add :sales_price, :decimal
      add :sales_amount, :decimal
      add :buy_price, :decimal
      add :discount, :decimal
      add :cash_amount, :decimal
      add :difference, :decimal
      add :pos_ref, :string
      add :pos_amount, :decimal
      add :sales_channel, :string
      add :payment_method, :string
      add :sales_status, :string
      add :reversed, :boolean, default: false, null: false
      add :cart_item_id, references(:cart_items, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:sales, [:id])
    create index(:sales, [:cart_item_id])
    create index(:sales, [:pickup_centre_id])
    create index(:sales, [:staff_id])
  end
end
