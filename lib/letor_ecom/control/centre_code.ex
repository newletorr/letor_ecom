defmodule LetorEcom.Control.CentreCode do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Control.EcommerceControl
  alias LetorEcom.Centres.PickupCentre

  schema "centre_code" do
    field :centre_code, :string, read_after_writes: true
    field :centre_name, :string, read_after_writes: true
    has_many(:ecommerce_controls, EcommerceControl)

    has_many(:pickup_centres, PickupCentre)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(centre_code, attrs) do
    centre_code
    |> cast(attrs, [:centre_code, :centre_name])
    |> validate_required([:centre_name])
    |> unique_constraint(:centre_name)
    |> gen_centre_code
  end

  defp gen_centre_code(changeset) do
    case changeset.valid? do
      true ->
        centre_name = get_field(changeset, :centre_name)

        centre_name_upcase =
          centre_name
          |> binary_part(0, 3)
          |> String.upcase()

        centre_code = centre_name_upcase <> gen_unique_code()

        changeset |> put_change(:centre_code, centre_code)

      _ ->
        changeset
    end
  end

  defp gen_unique_code() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 6
    value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

    actual_value =
      value
      |> String.upcase()

    actual_value
  end
end
