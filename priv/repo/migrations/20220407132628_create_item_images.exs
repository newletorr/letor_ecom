defmodule LetorEcom.Repo.Migrations.CreateItemImages do
  use Ecto.Migration

  def change do
    create table(:item_images, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :item_name, :string
      add :item_image1, :string
      add :item_image2, :string
      add :item_image3, :string
      add :item_image4, :string
      add :video_url, :string

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:item_images, [:ecommerce_control_id])
    create index(:item_images, [:id])
  end
end
