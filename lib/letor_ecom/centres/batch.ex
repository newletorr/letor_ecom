defmodule LetorEcom.Centres.Batch do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{Inventory, PickupCentre}
  alias LetorEcom.HumanResource.Staff

  schema "batches" do
    field(:code, :string, read_after_writes: true)
    # batch_type => suppliers, farmers, internal purchase
    field(:batch_type, :string, read_after_writes: true)
    field(:name, :string, read_after_writes: true)
    field(:description, :string, read_after_writes: true)
    field(:expiry_date, :date, read_after_writes: true)
    field(:expired, :boolean, read_after_writes: true)
    field(:quality_assurance_cleared, :boolean, read_after_writes: true)
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:staff, Staff)
    has_one(:inventory, Inventory)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(batch, attrs) do
    batch
    |> cast(attrs, [
      :name,
      :batch_type,
      :staff_id,
      :pickup_centre_id,
      :code,
      :description,
      :expiry_date,
      :expired,
      :quality_assurance_cleared
    ])
    |> validate_required([:pickup_centre_id, :description, :batch_type])
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:staff)
    |> gen_code
    |> gen_batch_name
  end

  defp gen_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 5
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        code =
          value
          |> String.upcase()

        changeset |> put_change(:code, code)

      _ ->
        changeset
    end
  end

  defp gen_batch_name(changeset) do
    case changeset.valid? do
      true ->
        pickup_centre_id = get_field(changeset, :pickup_centre_id)

        count_batch =
          Repo.one(
            from(batch in __MODULE__,
              join: pickup_centre in assoc(batch, :pickup_centre),
              where:
                batch.pickup_centre_id ==
                  ^pickup_centre_id,
              select: count(batch.id)
            )
          )

        if is_nil(count_batch) == true do
          name = "Batch" <> "-" <> "000"

          changeset |> put_change(:name, name)
        else
          if is_nil(count_batch) == false and length(Integer.digits(count_batch)) == 1 do
            name = "Batch" <> "-" <> "00" <> "#{count_batch}"
            changeset |> put_change(:name, name)
          else
            if is_nil(count_batch) == false and length(Integer.digits(count_batch)) == 2 do
              name = "Batch" <> "-" <> "0" <> "#{count_batch}"
              changeset |> put_change(:name, name)
            else
              if is_nil(count_batch) == false and length(Integer.digits(count_batch)) >= 3 do
                name = "Batch" <> "-" <> "#{count_batch}"
                changeset |> put_change(:name, name)
              end
            end
          end
        end

      _ ->
        changeset
    end
  end
end
