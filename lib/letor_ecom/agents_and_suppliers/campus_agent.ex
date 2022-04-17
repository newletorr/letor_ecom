defmodule LetorEcom.AgentsAndSuppliers.CampusAgent do
  use LetorEcom.SchemaHelper
  alias LetorEcom.CustomerPurchases.Order

  schema "campus_agents" do
    field :business_address, :string
    field :email, :string
    field :first_name, :string
    field :guarantor_first_name, :string
    field :guarantor_phone, :string
    field :guarantor_residential_address, :string
    field :guarantor_second_name, :string
    field :home_town, :string
    field :id_image, :string
    field :last_name, :string
    field :means_of_id, :string
    field :nationality, :string
    field :phone, :string
    field :residential_address, :string
    field :secret_code, :string
    field :state_of_origin, :string
    field :status, :string
    field :verified, :string
    belongs_to(:location, Location)
    belongs_to(:ecommerce_control, EcommerceControl)
    has_many(:order, Order)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(campus_agent, attrs) do
    campus_agent
    |> cast(attrs, [
      :location_id,
      :ecommerce_control_id,
      :residential_address,
      :business_address,
      :email,
      :first_name,
      :last_name,
      :phone,
      :status,
      :verified,
      :secret_code,
      :nationality,
      :home_town,
      :state_of_origin,
      :means_of_id,
      :id_image,
      :guarantor_first_name,
      :guarantor_second_name,
      :guarantor_phone,
      :guarantor_residential_address
    ])
    |> validate_required([
      :location_id,
      :ecommerce_control_id,
      :residential_address,
      :business_address,
      :email,
      :first_name,
      :last_name,
      :phone,
      :status,
      :verified,
      :secret_code,
      :nationality,
      :home_town,
      :state_of_origin,
      :means_of_id,
      :id_image,
      :guarantor_first_name,
      :guarantor_second_name,
      :guarantor_phone,
      :guarantor_residential_address
    ])
    |> assoc_constraint(:location)
    |> assoc_constraint(:ecommerce_control)
  end
end
