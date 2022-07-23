defmodule LetorEcom.HumanResource.Driver do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.HumanResource.Staff

  schema "drivers" do
    field :email, :string
    field :name, :string
    field :phone, :string
    # status => "on-duty" "off duty" "in-active"
    field :status, :string
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:staff, Staff)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:staff_id, :pickup_centre_id, :email, :name, :status, :phone])
    |> validate_required([:staff_id, :pickup_centre_id])
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> valid_phone(:phone)
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:staff)
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
