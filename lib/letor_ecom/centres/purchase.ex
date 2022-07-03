defmodule LetorEcom.Centres.Purchase do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{PickupCentre, PurchaseItem}
  alias LetorEcom.HumanResource.Staff

  schema "purchases" do
    field(:approval_remark, :string, read_after_writes: true)
    field(:code, :string, read_after_writes: true)
    field(:quality_assurance_cleared, :boolean, default: false, read_after_writes: true)
    # purchases status => initialized, approved, delivered, cancelled, disaproved
    field(:status, :string, read_after_writes: true)
    belongs_to(:staff, Staff)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:purchase_items, PurchaseItem)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [
      :pickup_centre_id,
      :code,
      :approval_remark,
      :status,
      :quality_assurance_cleared
    ])
    |> assoc_constraint(:pickup_centre)
    |> gen_purchase_code
  end

  def update_changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [
      :code,
      :approval_remark,
      :status,
      :quality_assurance_cleared
    ])
  end

  defp gen_purchase_code(changeset) do
    case changeset.valid? do
      true ->
        pickup_centre_id = get_field(changeset, :pickup_centre_id)

        count =
          Repo.one(
            from(purchase in __MODULE__,
              join: pickup_centre in assoc(purchase, :pickup_centre),
              where:
                purchase.pickup_centre_id ==
                  ^pickup_centre_id,
              select: count(purchase.id)
            )
          )

        if is_nil(count) == true do
          code = "0000"

          changeset |> put_change(:code, code)
        else
          if is_nil(count) == false and length(Integer.digits(count)) == 1 do
            code = "00" <> "#{count}" <> "00"
            changeset |> put_change(:code, code)
          else
            if is_nil(count) == false and length(Integer.digits(count)) == 2 do
              code = "00" <> "#{count}" <> "0"
              changeset |> put_change(:code, code)
            else
              if is_nil(count) == false and length(Integer.digits(count)) >= 3 do
                code = "00" <> "#{count}"
                changeset |> put_change(:code, code)
              end
            end
          end
        end

      _ ->
        changeset
    end
  end
end
