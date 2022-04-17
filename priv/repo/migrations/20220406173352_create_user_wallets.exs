defmodule LetorEcom.Repo.Migrations.CreateUserWallets do
  use Ecto.Migration

  def change do
    create table(:user_wallets, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :amount, :decimal
      add :wallet_id, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:user_wallets, [:id])
    create index(:user_wallets, [:user_id])
  end
end
