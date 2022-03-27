defmodule LetorEcom.Account.User do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.Address

  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/
  schema "users" do
    field :address, :string, read_after_writes: true
    field :business_name, :string, read_after_writes: true
    field :confirmation_code, :string, read_after_writes: true
    field :confirmation_sent_at, :utc_datetime
    field :confirmed_at, :utc_datetime
    field :current_sign_at, :utc_datetime
    field :current_sign_in_ip, :string
    field :current_sign_in_location, :string
    field :date_of_birth, :date, read_after_writes: true
    field :email, :string, read_after_writes: true
    field :facebood_id, :string
    field :first_name, :string, read_after_writes: true
    field :first_referal_earned, :boolean, default: false
    field :fourth_referal_earned, :string
    field :full_name, :string, read_after_writes: true
    field :image, :string
    field :last_name, :string, read_after_writes: true
    field :last_sign_in_at, :utc_datetime
    field :last_sign_in_ip, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :phone, :string, read_after_writes: true
    field :referal_code, :string
    field :referal_points_earned, :string
    field :role, :string, read_after_writes: true
    field :second_referal_earned, :string
    field :sign_in_count, :integer
    field :third_referal_eearned, :string
    has_one(:addresses, Address)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :facebood_id,
      :image,
      :first_name,
      :last_name,
      :full_name,
      :business_name,
      :address,
      :date_of_birth,
      :phone,
      :role,
      :current_sign_in_location,
      :current_sign_at,
      :last_sign_in_at,
      :sign_in_count,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :confirmation_code,
      :confirmed_at,
      :confirmation_sent_at,
      :referal_code,
      :first_referal_earned,
      :second_referal_earned,
      :third_referal_eearned,
      :fourth_referal_earned,
      :referal_points_earned,
      :password,
      :password_confirmation,
      :password_hash
    ])
    |> validate_required([
      :email,
      :first_name,
      :last_name,
      :address,
      :date_of_birth,
      :phone
      # :password,
      # :password_confirmation
    ])
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> unique_constraint(:referal_code)
    |> validate_length(:address,
      message: "Your address should be at list 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 4, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 4, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at list one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at list one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at list one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> hash_password()
    |> set_role("customer")
    |> valid_phone(:phone)
    |> create_full_name()
  end

  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation, :password_hash])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at list one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at list one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at list one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> hash_password()
  end

  # set users role
  defp set_role(changeset, role) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :role, role)

      _ ->
        changeset
    end
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end

  @spec valid_phone(Ecto.Changeset.t(), atom()) :: <<_::200>> | Ecto.Changeset.t()
  def valid_phone(changeset, field) do
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
