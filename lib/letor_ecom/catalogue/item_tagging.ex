defmodule LetorEcom.Catalogue.ItemTagging do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.{Item, ItemTag}

  schema "item_taggings" do
    belongs_to(:item, Item)
    belongs_to(:item_tag, ItemTag)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(item_tagging, attrs) do
    item_tagging
    |> cast(attrs, [:item_id, :item_tag_id])
    |> validate_required([:item_id, :item_tag_id])
    |> assoc_constraint(:item)
    |> assoc_constraint(:item_tag)
  end
end
