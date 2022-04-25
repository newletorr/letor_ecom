defmodule LetorEcom.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :address1, :string
      add :address2, :string
      add :business_name, :string
      add :order_instruction, :string
      add :zip_code, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:addresses, [:id])
    create index(:addresses, [:user_id])
  end
end
