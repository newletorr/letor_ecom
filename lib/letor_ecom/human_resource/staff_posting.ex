defmodule LetorEcom.HumanResource.StaffPosting do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Repo

  schema "staff_postings" do
    field :date_posted, :date
    field :previous_posting, :string
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:ecommerce_control, EcommerceControl)
    belongs_to(:staff, Staff)
    #belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @spec stores_postings_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def stores_postings_changeset(staff_posting, attrs) do
    staff_posting
    |> cast(attrs, [:pickup_centre_id, :date_posted, :previous_posting])
    |> validate_required([:date_posted, :previous_posting])
    |> assoc_constraint(:pickup_centre)
    |> get_previous_posting
  end

  @spec control_postings_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def control_postings_changeset(staff_posting, attrs) do
    staff_posting
    |> cast(attrs, [:ecommerce_control_id, :date_posted, :previous_posting])
    |> assoc_constraint(:ecommerce_control)
    |> get_previous_posting
  end

  @spec posting_update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def posting_update_changeset(staff_posting, attrs) do
    staff_posting
    |> cast(attrs, [:ecommerce_control_id, :pickup_centre_id, :date_posted, :previous_posting])
    |> assoc_constraint(:ecommerce_control)
    |> assoc_constraint(:pickup_centre)
  end

  defp get_previous_posting(changeset) do
    case changeset.valid? do
      true ->
        staff_id = get_field(changeset, :staff_id)

        query1 =
          from staff_posting in __MODULE__,
            join: ecommerce_control in assoc(staff_posting, :ecommerce_control),
            where: staff_posting.staff_id == ^staff_id,
            select: ecommerce_control.name

        control_centre_name = query1 |> last(:inserted_at) |> Repo.one()

        query2 =
          from staff_posting in __MODULE__,
            join: pickup_centre in assoc(staff_posting, :pickup_centre),
            where: staff_posting.staff_id == ^staff_id,
            select: pickup_centre.name

        store_name = query2 |> last(:inserted_at) |> Repo.one()

        if is_nil(control_centre_name) == false do
          changeset |> put_change(:previous_posting, control_centre_name)
        else
          changeset |> put_change(:previous_posting, store_name)
        end

      _ ->
        changeset
    end
  end
end
