defmodule LetorEcom.Catalogue.ItemTag do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Catalogue.ItemTagging

  schema "item_tag" do
    field :class, :string, read_after_writes: true
    field :description, :string, read_after_writes: true
    field :name, :string, read_after_writes: true
    has_many(:item_taggings, ItemTagging)

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
  def changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name, :class])
    |> validate_required([:description, :name, :class])
    |> unique_constraint(:name, message: "Already exists")
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def update_changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name, :class])
    |> unique_constraint(:name, message: "Already exists")
  end
end
