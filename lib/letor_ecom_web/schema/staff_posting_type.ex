defmodule LetorEcomWeb.Schema.Types.StaffPostingType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  # Control
  alias LetorEcom.{Accounts, HumanResource}
  alias LetorEcom.HumanResource.StaffPosting
  alias LetorEcom.Repo
  alias LetorEcomWeb.Schema.Middleware

  object :staff_posting_type do
    field :id, :id
    field :date_posted, :date
    field :previous_posting, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime

    # field(:pickup_centre, non_null(:pickup_centres_type),
    # resolve: dataloader(Control, :pickup_centre, args: %{deleted: false})
    # )

    field(:user, list_of(:user_type),
      resolve: dataloader(Accounts, :user, args: %{deleted: false})
    )

    # field(:staff, list_of(:staff_type),
    # resolve: dataloader(HumanResource, :staff, args: %{deleted: false})
    # )

    # field(:ecommerce_control, list_of(:ecommerce_control_type),
    # resolve: dataloader(Control, :ecommerce_control, args: %{deleted: false})
    # )
  end

  input_object :staff_posting_input_type do
    field :date_posted, :date
    field :previous_posting, :string
  end

  object :staff_posting_mutation do
    field :create_staff_posting, :staff_posting_type, description: "Create a new staff posting" do
      arg(:input, non_null(:staff_posting_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: context} ->
        main_input = Map.put(input, :user_id, context[:current_user].id)

        case HumanResource.create_staff_posting(main_input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_staff_posting, :staff_posting_type, description: "Update staff_posting" do
      arg(:staff_posting_id, non_null(:id))
      arg(:input, non_null(:staff_posting_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        staff_posting =
          StaffPosting
          |> preload([
            # :pickup_centre,
            # :users,
            # :ecommerce_control,
            # :staff
          ])
          |> Repo.get!(args[:staff_posting_id])

        case HumanResource.update_staff_posting(
               staff_posting,
               params
             ) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_staff_posting, :staff_posting_type, description: "Delete staff_posting" do
      arg(:staff_posting_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        staff_posting =
          StaffPosting
          |> preload([
            # :pickup_centre,
            # :users,
            # :ecommerce_control,
            # :staff
          ])
          |> Repo.get!(args[:staff_posting_id])

        case HumanResource.delete_staff_posting(staff_posting) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :staff_posting_query do
    field :staff_posting, list_of(:staff_posting_type), description: "Get list of staff_posting" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        staff_posting =
          StaffPosting
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, staff_posting}
      end)
    end
  end
end
