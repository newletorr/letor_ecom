defmodule LetorEcom.Account.ViewedItem do
  use LetorEcom.SchemaHelper

  schema "viewed_items" do
    belongs_to(:user, User)
    belongs_to(:item, Item)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(viewed_item, attrs) do
    viewed_item
    |> cast(attrs, [:user_id, :item_id])
    |> validate_required([:item_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:item)
    |> delete_old_viewed_item
  end

  defp delete_old_viewed_item(changeset) do
    case changeset.valid? do
      true ->
        user_id = get_field(changeset, :user_id)

        count =
          Repo.all(
            from view_item in ViewItem, where: view_item.user_id == ^user_id, select: count("*")
          )

        query1 = from(view_item in ViewItem, where: view_item.user_id == ^user_id)
        item = query1 |> first(:inserted_at) |> Repo.one()

        case count >= 20 do
          true ->
            Repo.delete(item)

            changeset

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end
end
