defmodule LetorEcom.Repo.Migrations.CreateAddressBook do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create table(:address_books, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :address, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :area, :string, null: false
      add :zip_code, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:address_books, [:id])
    create index(:address_books, [:user_id])
    create unique_index(:address_books, [:address, :user_id], name: "address_books_address_user_id_ix")
    execute("SELECT AddGeometryColumn('address_books', 'coordinates', 4326, 'POINT', 2)")

    execute(
      "CREATE INDEX address_books_coordinates_index on address_books USING gist (coordinates)"
    )
  end

  def down do
    drop table(:address_books)
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end
