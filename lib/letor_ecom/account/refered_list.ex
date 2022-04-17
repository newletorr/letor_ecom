defmodule LetorEcom.Account.ReferedList do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User

  schema "refered_lists" do
    field :date_activated, :utc_datetime
    field :refered_person_id, :string
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(refered_list, attrs) do
    refered_list
    |> cast(attrs, [:user_id, :date_activated, :refered_person_id])
    |> validate_required([:user_id, :date_activated, :refered_person_id])
    |> assoc_constraint(:user)
  end
end
