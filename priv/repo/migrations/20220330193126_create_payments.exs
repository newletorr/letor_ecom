defmodule LetorEcom.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :transaction_id, :integer
      add :reference_code, :string
      add :authorization_url, :string
      add :amount, :decimal
      add :verified, :boolean, default: false, null: false
      add :ip_address, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:payments, [:id])
    create index(:payments, [:user_id])
  end
end
