defmodule LetorEcom.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staff, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :country, :string
      add :id_code, :string
      add :date_employed, :date
      add :residential_address, :string
      add :designation, :string
      add :email, :string
      add :employment_status, :string
      add :first_name, :string
      add :full_name, :string
      add :guarantor_address, :string
      add :guarantor_name, :string
      add :guarantor_phone, :string
      add :means_of_id, :string
      add :id_image, :string
      add :home_town, :string
      add :last_name, :string
      add :lga, :string
      add :state_of_origin, :string
      add :phone, :string

      timestamps(type: :timestamptz)
    end

    create index(:staff, [:id])
  end
end
