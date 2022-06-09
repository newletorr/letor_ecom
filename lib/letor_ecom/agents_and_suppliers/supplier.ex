defmodule LetorEcom.AgentsAndSuppliers.Supplier do
  use Waffle.Ecto.Schema
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.Control.EcommerceControl
  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  schema "suppliers" do
    field(:address, :string)
    field(:business_name, :string)
    field(:city, :string)
    field(:contact_person, :string)
    field(:country, :string)
    field(:email, :string)
    field(:first_name, :string)
    field(:full_name, :string)
    field(:last_name, :string)
    field(:means_of_id, :string)
    # LetorEcom.Uploads.Type
    field(:logo, :string)
    # LetorEcom.Uploads.Type
    field(:image, :string)
    # LetorEcom.Uploads.Type
    field(:id_image, :string)
    field(:national_supplier, :boolean, default: false)
    field(:phone, :string)
    field(:rc_number, :string)
    field(:regional_supplier, :boolean, default: false)
    field(:state, :string)
    field(:status, :string)
    field(:type, :string)
    field(:verified, :boolean, default: false)
    belongs_to(:ecommerce_control, EcommerceControl)
    belongs_to(:location, Location)
    has_one(:users, User)
    timestamps(type: :utc_datetime)
  end

  defp all_fields do
    __MODULE__.__schema__(:fields)
  end

  @doc false
  def individual_supplier_changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [
      :ecommerce_control_id,
      :location_id,
      :address,
      :status,
      :type,
      :means_of_id,
      :first_name,
      :last_name,
      :full_name,
      :image,
      :logo,
      :id_image,
      :email,
      :phone,
      :verified,
      :city,
      :state,
      :country,
      :regional_supplier,
      :national_supplier
    ])
    # |> cast_attachments(attrs, [:id_image, :image, :logo])
    |> validate_required([
      :address,
      :status,
      :type,
      :means_of_id,
      :id_image,
      :first_name,
      :last_name,
      :email,
      :phone,
      :city,
      :state,
      :country
    ])
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_format(:business_name, ~r/^[a-zA-Z_-]+$/,
      message: "Name must only contain letters"
    )
    |> valid_phone(:phone)
    |> assoc_constraint(:ecommerce_control)
    |> assoc_constraint(:location)
    |> create_full_name()
  end

  def corporate_supplier_changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [
      :ecommerce_control_id,
      :location_id,
      :address,
      :status,
      :type,
      :contact_person,
      :rc_number,
      :business_name,
      :logo,
      :email,
      :phone,
      :verified,
      :city,
      :state,
      :country,
      # An ecommerce control will be specified when regional supplier is selected on the client
      :regional_supplier,
      :national_supplier
    ])
    |> cast_attachments(attrs, [:logo])
    |> validate_required([
      :address,
      :status,
      :type,
      :contact_person,
      :rc_number,
      :business_name,
      :email,
      :phone,
      :city,
      :state,
      :country
    ])
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_format(:business_name, ~r/^[a-zA-Z_-]+$/,
      message: "Name must only contain letters"
    )
    |> valid_phone(:phone)
    |> valid_phone(:phone)
    |> assoc_constraint(:ecommerce_control)
    |> assoc_constraint(:location)
  end

  def update_changeset(supplier, attrs) do
    supplier
    |> cast(attrs, all_fields())
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_format(:business_name, ~r/^[a-zA-Z_-]+$/,
      message: "Name must only contain letters"
    )
    |> valid_phone(:phone)
    |> create_full_name()
    |> assoc_constraint(:location)
  end

  def supplier_verification_changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:verified])
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

  defp create_full_name(changeset) do
    case changeset.valid? do
      true ->
        first_name = get_field(changeset, :first_name)
        last_name = get_field(changeset, :last_name)

        if is_nil(first_name) == false and is_nil(last_name) == false do
          full_name = first_name <> " " <> last_name

          changeset
          |> put_change(:full_name, full_name)
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end
