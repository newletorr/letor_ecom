defmodule LetorEcom.Control.EcommerceControl do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre

  schema "ecommerce_controls" do
    field :country, :string
    field :name, :string
    field :region, :string
    belongs_to(:centre_code, CentreCode)
    has_many(:pickup_centres, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ecommerce_control, attrs) do
    ecommerce_control
    |> cast(attrs, [:centre_code_id, :name, :region, :country])
    |> validate_required([:centre_code_id, :name, :region, :country])
    |> assoc_constraint(:centre_code)
  end
end
