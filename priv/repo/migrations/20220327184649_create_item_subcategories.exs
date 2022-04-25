defmodule LetorEcom.Repo.Migrations.CreateItemSubcategories do
  use Ecto.Migration

  def change do
    create table(:item_subcategories, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string
      add :description, :string
      add :item_category_id, references(:item_categories, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:item_subcategories, [:id])
    create index(:item_subcategories, [:item_category_id])
    create unique_index(:item_subcategories, [:name])
  end
end
