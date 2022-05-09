defmodule LetorEcom.Repo.Migrations.CreateUserFavs do
  use Ecto.Migration

  def change do
    create table(:user_favs, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:user_favs, [:id])
    create index(:user_favs, [:user_id])
    create unique_index(:user_favs, [:item_id, :user_id], name: "users_fav_item_id_user_id_index")
  end
end
