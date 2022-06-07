defmodule LetorEcom.AgentsAndSuppliers.Agent do
  use LetorEcom.SchemaHelper
  use Waffle.Ecto.Schema
  alias LetorEcom.Account.User
  alias LetorEcom.Control.{EcommerceControl, Location}
  alias LetorEcom.CustomerPurchases.Order

  @required_fields ~w(covered_institution_id ecommerce_control_id location_id residential_address business_address email first_name last_name phone status verified nationality home_town state_of_origin means_of_id guarantor_first_name guarantor_last_name guarantor_phone guarantor_residential_address)a

  @image_fields [:agents_image, :id_image]
  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  schema "agents" do
    field(:business_address, :string)
    field(:email, :string)
    # LetorEcom.Uploads.Type)
    field :agents_image, :string
    field(:first_name, :string)
    field(:guarantor_first_name, :string)
    field(:guarantor_phone, :string)
    field(:guarantor_residential_address, :string)
    field(:guarantor_last_name, :string)
    field(:home_town, :string)
    # LetorEcom.Uploads.Type)
    field :id_image, :string
    field(:last_name, :string)
    field(:means_of_id, :string)
    field(:nationality, :string)
    field(:phone, :string)
    field(:residential_address, :string)
    field(:secret_code, :string)
    field(:state_of_origin, :string)
    field(:status, :string)
    field(:verified, :boolean)
    field(:guarantor_verified, :boolean)
    belongs_to(:ecommerce_control, EcommerceControl)
    belongs_to(:location, Location)
    has_many(:order, Order)
    has_many(:users, User)

    timestamps(type: :utc_datetime)
  end

  defp all_fields do
    __MODULE__.__schema__(:fields)
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
  def changeset(agent, attrs) do
    agent
    |> cast(attrs, all_fields())
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "An agent with the same email already exists")
    |> unique_constraint(:phone, message: "An agent with the same phone number already exists")
    |> validate_required(@required_fields)
    |> assoc_constraint(:covered_institution, name: :covered_institution_campus_agents_index)
    |> assoc_constraint(:ecommerce_control, name: :ecommerce_control_campus_agents_index)
    |> valid_phone(:phone)
    |> valid_phone(:guarantor_phone)
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def update_changeset(agent, attrs) do
    agent
    |> cast(attrs, all_fields())
    |> assoc_constraint(:covered_institution)
    |> assoc_constraint(:ecommerce_control)
  end

  def images_upload_changeset(agent, attrs) do
    agent
    |> cast(attrs, @image_fields)
    |> validate_required(@image_fields)
    |> cast_attachments(attrs, @image_fields, allow_urls: true)
  end

  defp valid_phone(changeset, field) do
    phone = get_field(changeset, field)

    if is_nil(phone) == false do
      {:ok, phone_number} = ExPhoneNumber.parse(phone, "NG")

      case ExPhoneNumber.is_valid_number?(phone_number) do
        true -> changeset
        _ -> "Invalid phone number"
      end
    else
      changeset
    end
  end
end
