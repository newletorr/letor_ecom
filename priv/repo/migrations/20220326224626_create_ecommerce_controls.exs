defmodule LetorEcom.Repo.Migrations.CreateEcommerceControls do
  use Ecto.Migration

  def change do
    create table(:ecommerce_controls, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string
      add :region, :string
      add :country, :string
      add :centre_code, :string
      add :office_address, :string

      timestamps(type: :timestamptz)
    end

    create index(:ecommerce_controls, [:id])
    create unique_index(:ecommerce_controls, [:name])
    create unique_index(:ecommerce_controls, [:region])
  end
end
