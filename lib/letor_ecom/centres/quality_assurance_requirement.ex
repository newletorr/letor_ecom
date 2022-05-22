defmodule LetorEcom.Centres.QualityAssuranceRequirement do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{Inventory, PickupCentre}
  alias LetorEcom.HumanResource.Staff

  schema "quality_assurance_requirements" do
    field :acceptable_quantity_of_damage_item, :boolean, default: false, read_after_writes: true
    field :broken_seal, :boolean, default: false, read_after_writes: true
    field :damaged_containers, :boolean, default: false, read_after_writes: true
    field :describe_firmness, :string, read_after_writes: true
    field :describe_observed_fungal_growth, :string, read_after_writes: true
    field :expired, :boolean, default: false, read_after_writes: true
    field :expiry_date, :date, read_after_writes: true
    field :firmness, :boolean, default: false, read_after_writes: true
    field :good_color, :string, read_after_writes: true
    field :no_of_rusty_cans, :integer, read_after_writes: true
    field :number_of_damaged_containers, :integer, read_after_writes: true
    field :number_of_items_with_broken_seal, :integer, read_after_writes: true
    field :observed_fungal_growth, :boolean, default: false, read_after_writes: true
    field :product_type, :string, read_after_writes: true
    field :rusty_cans, :boolean, default: false, read_after_writes: true
    belongs_to(:inventory, Inventory)
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:staff, Staff)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quality_assurance_requirement, attrs) do
    quality_assurance_requirement
    |> cast(attrs, [
      :acceptable_quantity_of_damage_item,
      :broken_seal,
      :number_of_items_with_broken_seal,
      :damaged_containers,
      :number_of_damaged_containers,
      :expired,
      :expiry_date,
      :firmness,
      :describe_firmness,
      :good_color,
      :observed_fungal_growth,
      :describe_observed_fungal_growth,
      :product_type,
      :rusty_cans,
      :no_of_rusty_cans
    ])
  end
end
