defmodule LetorEcom.Account.AddressBook do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias Geo.PostGIS.Geometry

  schema "address_books" do
    field :address, :string, read_after_writes: true
    field :city, :string, read_after_writes: true
    field :area, :string, read_after_writes: true
    field :state, :string, read_after_writes: true
    field :zip_code, :string, read_after_writes: true
    field :coordinates, Geometry
    belongs_to(:user, User)
    has_many(:orders, Order)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:user_id, :address, :city, :state, :zip_code, :area, :coordinates])
    |> validate_required([:address, :city, :area, :state])
    |> assoc_constraint(:user)
  end

  def deletion_changeset(address, attrs \\ %{}) do
    address
    |> assoc_constraint(:user)
  end
end
