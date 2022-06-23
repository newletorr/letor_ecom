defmodule LetorEcom.Account.User do
  use Waffle.Ecto.Schema
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.{Address, ReferedList, ShoppingList, UserFav}
  alias LetorEcom.AgentsAndSuppliers.{Agent, Supplier}
  alias LetorEcom.Control.Location
  alias LetorEcom.CustomerPurchases.Order
  alias LetorEcom.HumanResource.{Staff, StaffPosting}
  alias LetorEcom.Sales.InstoreSale
  alias LetorEcom.Transactions.UserWallet

  @user_required_fields ~w(location_id email first_name last_name address  phone password password_confirmation)a
  @other_required_fields ~w(password password_confirmation)a

  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/
  schema "users" do
    field :address, :string, read_after_writes: true
    field :business_name, :string, read_after_writes: true
    field :confirmation_code, :string, read_after_writes: true
    field :confirmation_sent_at, :utc_datetime
    field :confirmed_at, :utc_datetime
    field :current_sign_in_at, :utc_datetime
    field :current_sign_in_ip, :string
    field :current_sign_in_location, :string
    field :user_image, :string, read_after_writes: true
    field :date_of_birth, :date, read_after_writes: true
    field :email, :string, read_after_writes: true
    field :facebood_id, :string
    field :first_name, :string, read_after_writes: true
    field :first_referal_earned, :boolean, default: false
    field :fourth_referal_earned, :string
    field :full_name, :string, read_after_writes: true
    field :image, LetorEcom.Uploads.Type
    field :last_name, :string, read_after_writes: true
    field :last_sign_in_at, :utc_datetime
    field :last_sign_in_ip, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :phone, :string, read_after_writes: true
    field :referal_code, :string
    field :referal_points_earned, :integer
    field :role, :string, read_after_writes: true
    field :second_referal_earned, :string
    field :sign_in_count, :integer
    field :third_referal_earned, :string
    field(:inputed_code, :string, virtual: true)
    has_one(:addresses, Address)
    has_one(:staff_posting, StaffPosting)
    has_one(:user_wallets, UserWallet)
    has_many(:refered_lists, ReferedList)
    has_many(:shopping_list, ShoppingList)
    has_many(:user_fav, UserFav)
    has_many(:instore_sales, InstoreSale)
    has_many(:orders, Order)
    belongs_to(:location, Location)
    belongs_to(:agent, Agent)
    belongs_to(:supplier, Supplier)
    belongs_to(:staff, Staff)

    timestamps(type: :utc_datetime)
  end

  defp all_fields do
    [:password, :password_confirmation | __MODULE__.__schema__(:fields)]
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
  def changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_required(@user_required_fields)
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> unique_constraint(:referal_code)
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> assoc_constraint(:location)
    |> hash_password()
    |> set_role("customer")
    |> valid_phone(:phone)
    |> create_full_name()
    |> gen_referal_code
  end

  def agents_changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_required(@other_required_fields)
    |> validate_format(:email, @email_regex, message: "Email must have the @ sign and no spaces")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 5, max: 160)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "A user with the same phone number already exists")
    |> unique_constraint(:referal_code)
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15
    )
    |> validate_length(:first_name, min: 2, max: 40)
    |> validate_format(:first_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:last_name, min: 2, max: 40)
    |> validate_format(:last_name, ~r/^[a-zA-Z_-]+$/, message: "Name must only contain letters")
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> assoc_constraint(:location)
    |> hash_password()
    |> valid_phone(:phone)
    |> create_full_name()
    |> assoc_constraint(:agent)
  end

  def supplier_changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_required(@other_required_fields)
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
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> assoc_constraint(:location)
    |> hash_password()
    |> valid_phone(:phone)
    |> assoc_constraint(:supplier)
    |> set_role("supplier")
  end

  def staff_changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_required(@other_required_fields)
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
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> hash_password()
    |> valid_phone(:phone)
    |> assoc_constraint(:staff)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, message: "A user with the same email already exists")
    |> unique_constraint(:phone, message: "Phone number has already been used")
    |> validate_length(:address,
      message: "Your address should be at least 15 characters long",
      min: 15,
      max: 40
    )
    |> assoc_constraint(:location)
    |> valid_phone(:phone)
    |> create_full_name
  end

  @spec update_referals_earned_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def update_referals_earned_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :referal_points_earned,
      :cum_referal_earned_points,
      :first_referal_earned,
      :second_referal_earned,
      :third_referal_earned,
      :fourth_referal_earned
    ])
  end

  def tracked_fields_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :current_sign_in_at,
      :last_sign_in_at,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :sign_in_count
    ])
  end

  @spec image_upload_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def image_upload_changeset(user, attrs) do
    user
    |> cast(attrs, [:user_image])
    |> cast_attachments(attrs, [:user_image], allow_urls: true)
  end

  @spec password_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation, :password_hash])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have at least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "password does not match")
    |> hash_password()
  end

  def staff_changeset(user, attrs) do
    user
    |> cast(attrs, all_fields())
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:staff_id,
      message: "Email has already been used by another Staff",
      name: :users_staff_id_email_index
    )
    |> unique_constraint(:staff_id,
      message: "Phone number has already been used by another Staff",
      name: :users_staff_id_phone_index
    )
    |> validate_required([
      :staff_id,
      :password,
      :password_confirmation
    ])
    |> assoc_constraint(:staff)
    |> valid_phone(:phone)
    |> create_full_name
    |> validate_length(:password, min: 6, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: "Password should have a least one lower case character."
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "Password should have at least one upper case character."
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "Password should have at least one digit or punctuation character."
    )
    |> validate_confirmation(:password, message: "Password does not match")
    |> hash_password
    |> get_staff_first_name
    |> get_staff_last_name
    |> create_full_name
    |> get_staff_email
    |> get_staff_role
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

  defp get_staff_first_name(changeset) do
    case changeset.valid? do
      true ->
        staff = Repo.get(Staff, get_field(changeset, :staff_id))
        first_name = staff.first_name

        changeset |> put_change(:first_name, first_name)

      _ ->
        changeset
    end
  end

  defp get_staff_last_name(changeset) do
    case changeset.valid? do
      true ->
        staff = Repo.get(Staff, get_field(changeset, :staff_id))
        last_name = staff.last_name

        changeset |> put_change(:last_name, last_name)

      _ ->
        changeset
    end
  end

  defp get_staff_email(changeset) do
    case changeset.valid? do
      true ->
        staff = Repo.get(Staff, get_field(changeset, :staff_id))

        email = staff.email

        changeset |> put_change(:email, email)

      _ ->
        changeset
    end
  end

  defp get_staff_role(changeset) do
    case changeset.valid? do
      true ->
        staff = Repo.get(Staff, get_field(changeset, :staff_id))

        role = staff.designation

        changeset |> put_change(:role, role)

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

  defp gen_referal_code(changeset) do
    case changeset.valid? do
      true ->
        name =
          get_field(changeset, :first_name)
          |> binary_part(0, 3)
          |> String.downcase()

        ref_code =
          referal_code_gen2()
          |> String.downcase()

        code = name <> ref_code

        changeset
        |> put_change(:referal_code, code)

      _ ->
        changeset
    end
  end

  @spec referal_code_gen2 :: bitstring
  def referal_code_gen2() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 4
    value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

    value
  end
end
