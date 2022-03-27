defmodule LetorEcom.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :email, :string
      add :facebood_id, :string
      add :image, :string
      add :first_name, :string
      add :last_name, :string
      add :full_name, :string
      add :business_name, :string
      add :password_hash, :string
      add :address, :string
      add :date_of_birth, :date
      add :phone, :string
      add :role, :string
      add :current_sign_in_location, :string
      add :current_sign_at, :utc_datetime
      add :last_sign_in_at, :utc_datetime
      add :sign_in_count, :integer
      add :current_sign_in_ip, :string
      add :last_sign_in_ip, :string
      add :confirmation_code, :string
      add :confirmed_at, :utc_datetime
      add :confirmation_sent_at, :utc_datetime
      add :referal_code, :string
      add :first_referal_earned, :boolean, default: false, null: false
      add :second_referal_earned, :string
      add :third_referal_eearned, :string
      add :fourth_referal_earned, :string
      add :referal_points_earned, :string

      timestamps(type: :timestamptz)
    end

    create index(:users, [:id])
    create unique_index(:users, [:email])
    create unique_index(:users, [:phone])
  end
end
