defmodule LetorEcom.Control.CoveredInstitution do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Control.{EcommerceControl, Location}

  schema "covered_institutions" do
    field :campus_name, :string
    field :name, :string
    belongs_to(:location, Location)
    belongs_to(:ecommerce_control, EcommerceControl)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(covered_institution, attrs) do
    covered_institution
    |> cast(attrs, [:location_id, :ecommerce_control_id, :name, :campus_name])
    |> validate_required([:location_id, :ecommerce_control_id, :name, :campus_name])
    |> unique_constraint(:campus_name,
      message: "Campus name already exist for this University",
      name: :covered_institutions_campus_name_name_index
    )
    |> assoc_constraint(:location)
    |> assoc_constraint(:ecommerce_control)
  end
end
