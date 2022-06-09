defmodule LetorEcom.HumanResource.Staff do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.User
  alias LetorEcom.HumanResource.{Driver, StaffPosting}
  alias LetorEcom.CustomerPurchases.OrderDispatch
  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  @code 5

  schema "staff" do
    field :country, :string
    field :date_employed, :date
    field :designation, :string
    field :email, :string
    field :employment_status, :string
    field :first_name, :string
    field :full_name, :string
    field :guarantor_address, :string
    field :guarantor_name, :string
    field :guarantor_phone, :string
    field :home_town, :string
    field :id_code, :string
    field :id_image, :string
    field :last_name, :string
    field :lga, :string
    field :means_of_id, :string
    field :phone, :string
    field :residential_address, :string
    field :state_of_origin, :string
    has_many(:driver, Driver)
    has_many(:order_dispatch, OrderDispatch)
    has_many(:staff_postings, StaffPosting)
    has_one(:users, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def update_changeset(staff, attrs) do
    staff
    |> cast(attrs, [
      :country,
      :id_code,
      :date_employed,
      :residential_address,
      :designation,
      :email,
      :employment_status,
      :first_name,
      :full_name,
      :guarantor_address,
      :guarantor_name,
      :guarantor_phone,
      :means_of_id,
      :home_town,
      :last_name,
      :lga,
      :state_of_origin,
      :phone
    ])
    |> validate_required([
      :country,
      :date_employed,
      :residential_address,
      :designation,
      :email,
      :employment_status,
      :first_name,
      :guarantor_address,
      :guarantor_name,
      :guarantor_phone,
      :means_of_id,
      :home_town,
      :last_name,
      :lga,
      :state_of_origin,
      :phone
    ])
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> valid_phone(:phone)
    |> valid_phone(:guarantor_phone)
    |> join_names()
  end

  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [
      :country,
      :id_code,
      :date_employed,
      :residential_address,
      :designation,
      :email,
      :employment_status,
      :first_name,
      :full_name,
      :guarantor_address,
      :guarantor_name,
      :guarantor_phone,
      :means_of_id,
      :home_town,
      :last_name,
      :lga,
      :state_of_origin,
      :phone
    ])
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> validate_length(:first_name, min: 4, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 4, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> valid_phone(:phone)
    |> valid_phone(:guarantor_phone)
    |> join_names()
  end

  defp join_names(changeset) do
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

  defp gen_staff_id_code(changeset) do
    case changeset.valid? do
      true ->
        name = get_field(changeset, :first_name)

        id_code = name <> __MODULE__.staff_code()

        changeset
        |> put_change(:id_code, id_code)

      _ ->
        changeset
    end
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

  def staff_code do
    code =
      5
      |> :math.pow(@code)
      |> round()
      |> :rand.uniform()
      |> Integer.to_string()
      |> String.pad_leading(@code, "0")

    code
  end
end
