defmodule LetorEcom.Repo.Migrations.CreateItemTaggings do
  use Ecto.Migration

  def change do
    create table(:item_taggings, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)
      add :item_tag_id, references(:item_tag, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:item_taggings, [:item_id])
    create index(:item_taggings, [:item_tag_id])
    create index(:item_taggings, [:id])
    create unique_index(:item_taggings, [:item_id], name: "item_taggings_item_id_index")
  end
end
