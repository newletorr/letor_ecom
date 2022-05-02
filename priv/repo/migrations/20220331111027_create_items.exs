defmodule LetorEcom.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :actual_price, :decimal
      add :available_quantity, :integer
      add :description, :string
      add :main_price, :decimal
      add :group_buying_price, :decimal
      add :name, :string
      add :regional_name, :string
      add :out_of_stock, :boolean, default: false, null: false
      add :package_size, :string
      add :promo_price, :decimal
      add :brand_name, :string
      add :type, :string
      add :qa_cleared, :boolean, default: false, null: false
      add :size, :integer
      add :item_code, :string
      add :expired, :boolean, default: false, null: false
      add :details, :string
      add :barcode, :string
      add :bulk, :boolean, default: false, null: false
      add :customization_allowed, :boolean, default: false, null: false
      add :preparation_time, :string
      add :availability_time, :string
      add :third_party_item, :string
      add :instore_location, :string
      add :qr_code, :string

      timestamps(type: :timestamptz)
    end

    create index(:items, [:id])
  end
end
