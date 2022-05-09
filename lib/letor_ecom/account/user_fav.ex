defmodule LetorEcom.Account.UserFav do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.Catalogue.Item

  schema "user_favs" do
    belongs_to(:item, Item)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_fav, attrs) do
    user_fav
    |> cast(attrs, [:item_id, :user_id])
    |> validate_required([:item_id])
    |> unique_constraint(:item_id,
      message: "You already have this item in your list of favourite items",
      name: :users_fav_item_id_user_id_index
    )
    |> assoc_constraint(:item)
    |> assoc_constraint(:user)
  end
end
