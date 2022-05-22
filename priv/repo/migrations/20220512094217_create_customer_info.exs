defmodule LetorEcom.Repo.Migrations.CreateCustomerInfo do
  use Ecto.Migration

  def change do
    create table(:customer_info, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :phone, :string
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :sale_id, references(:sales, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:customer_info, [:id])
    create index(:customer_info, [:user_id])
    create index(:customer_info, [:sale_id])
    create unique_index(:customer_info, [:phone])
  end
end
