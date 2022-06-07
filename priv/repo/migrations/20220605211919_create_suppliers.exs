defmodule LetorEcom.Repo.Migrations.CreateSuppliers do
  use Ecto.Migration

  def change do
    create table(:suppliers, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :address, :string
      add :status, :string
      add :type, :string
      add :contact_person, :string
      add :means_of_id, :string
      add :rc_number, :string
      add :first_name, :string
      add :image, :string
      add :id_image, :string
      add :logo, :string
      add :last_name, :string
      add :full_name, :string
      add :business_name, :string
      add :email, :string
      add :phone, :string
      add :verified, :boolean, default: false, null: false
      add :city, :string
      add :state, :string
      add :country, :string
      add :regional_supplier, :boolean, default: false, null: false
      add :national_supplier, :boolean, default: false, null: false

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      add :location_id,
          references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:suppliers, [:id])
    create index(:suppliers, [:location_id])
    create index(:suppliers, [:ecommerce_control_id])
  end
end
